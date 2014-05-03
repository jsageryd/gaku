# encoding: utf-8

module Gaku
  class CLI
    def initialize(argv)
      Signal.trap('SIGINT') { quit }
      @options = Options.new(argv).options
      @options[:stats] and raise 'Stats not implemented'
      @canvas = Canvas.new(CONF.monochrome?, CONF.utf8?)
      print_banner
      @input = Input.new
      @input.on_quit { quit }
      deck_name = @options[:deck] ? @options[:deck][:argument] : nil
      if deck_name.nil?
        @deck = ask_for_deck
      else
        if Croupier.decks.include?(deck_name)
          @deck = Croupier.load_deck(deck_name)
        else
          @canvas.puts("Invalid deck '#{deck_name}'")
          @canvas.puts('Available decks: ')
          print_decks(false)
          exit 1
        end
      end
      @canvas.puts("Deck '#{@deck.name}' loaded.")
      @canvas.puts
      quiz(@deck)
    end

    private

    def quit
      @canvas.puts
      @canvas.puts(Chatter.farewell)
      exit
    end

    def print_banner
      @canvas.puts('Gaku %s' % [Gaku::VERSION])
      @canvas.puts
    end

    def print_goodbye
      @canvas.puts
      @canvas.puts(Chatter.farewell)
    end

    def print_decks(id_prefix=true)
      Croupier.decks.each_with_index do |d, i|
        if id_prefix
          @canvas.puts('  %d) %s' % [i, d])
        else
          @canvas.puts('  %s' % [d])
        end
      end
    end

    def quiz(deck)
      loop do
        now = Time.now
        card = deck.first_card
        card[:last_seen] = now.to_i
        @canvas.puts(card[:front])
        if card.has_key?(:match)
          known = ask_for_match(card[:match])
          @canvas.print(known ? 'Correct. ' : 'Incorrect. ')
        else
          known = ask_if_known
        end
        card[:last_known] = now.to_i if known
        card[:known] = known
        distance = card.fetch(:distance, CONF.initial_distance)
        card[:distance] = known ? distance * 2 : distance / 2
        card[:distance] = 1 if card[:distance] < 1
        card[:distance] = 2 ** Math.log2(deck.length).ceil if card[:distance] > deck.length
        @canvas.puts("Moving down #{card[:distance]} place#{card[:distance] > 1 ? 's' : ''}.")
        @canvas.puts
        if not known
          @canvas.puts(card[:front])
          @canvas.puts
          @canvas.puts(card[:back])
          @canvas.puts
          if card.has_key?(:match)
            until ask_for_match(card[:match])
              next
            end
            @canvas.puts("Correct.")
            @canvas.puts
          end
        end
        deck.move_first(card[:distance])
        Croupier.save_deck(deck)
      end
    end

    def ask_for_deck
      @canvas.puts('Pick a deck:')
      print_decks
      deck = nil
      while deck.nil?
        begin
          id = @input.gets('> ').strip
          next unless id =~ /^\d+$/ && (0...Croupier.decks.length).cover?(id.to_i)
          deck = Croupier.load_deck(Croupier.decks[id.to_i])
        rescue InvalidDeck
          @canvas.puts('Invalid deck')
        end
      end
      deck
    end

    def ask_for_match(pattern)
      input = @input.gets('> ').strip
      if pattern =~ /^\/.*\/i?$/
        # Pattern is a regex
        regexp_str, options_str = pattern.match(/^\/(.*)\/(.*)$/)[1, 2]
        options = options_str == 'i' ? Regexp::IGNORECASE : nil
        !!(input.strip =~ Regexp.new(regexp_str, options))
      else
        # Pattern is a plain string
        input == pattern
      end
    end

    def ask_if_known
      known = nil
      while known.nil?
        input = @input.gets('Do you know this [y/n]? ')
        case input.strip.downcase
        when 'y', 'yes' then known = true
        when 'n', 'no'  then known = false
        else @canvas.puts('Please say yes or no.')
        end
      end
      known
    end
  end
end
