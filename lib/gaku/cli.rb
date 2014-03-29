# encoding: utf-8

module Gaku
  class CLI
    def initialize(argv)
      @config = Config.new
      exit 1 unless @config.valid?
      print_banner
      if argv.empty?
        @deck = ask_for_deck
        puts "Deck '#{@deck.name}' loaded."
        puts
      else
        deck_name = argv.shift
        argv.clear
        if Croupier.decks.include?(deck_name)
          @deck = Croupier.load_deck(deck_name)
          puts "Deck '#{@deck.name}' loaded."
          puts
        else
          puts "Invalid deck '#{deck_name}'"
          puts 'Available decks: '
          print_decks(false)
          exit 1
        end
      end
      quiz(@deck)
    end

    private

    def print_banner
      puts 'Gaku %s' % [Gaku::VERSION]
      puts
    end

    def print_goodbye
      puts
      puts [
        'All right then o/',
        'Another time then o/',
        'Catch you later o/',
        'Come back soon o/',
        'Farewell o/',
        'Good bye o/',
        'Miss you already o/',
        'Peace out o/',
        'See you soon o/',
        'So long o/',
        'Take care o/',
        'Tata o/',
        'Todilo o/'
      ].sample
    end

    def print_decks(id_prefix=true)
      Croupier.decks.each_with_index do |d, i|
        if id_prefix
          puts '  %d) %s' % [i, d]
        else
          puts '  %s' % [d]
        end
      end
    end

    def quiz(deck)
      loop do
        now = Time.now
        card = deck.first_card
        card[:last_seen] = now.to_i
        puts card[:front]
        if card.has_key?(:match)
          known = ask_for_match(card[:match])
          print known ? 'Correct. ' : 'Incorrect. '
        else
          known = ask_if_known
        end
        card[:last_known] = now.to_i if known
        card[:known] = known
        distance = card.fetch(:distance, @config.initial_distance)
        card[:distance] = known ? distance * 2 : distance / 2
        card[:distance] = 1 if card[:distance] < 1
        card[:distance] = 2 ** Math.log2(deck.length).ceil if card[:distance] > deck.length
        puts "Moving down #{card[:distance]} place#{card[:distance] > 1 ? 's' : ''}."
        puts
        if not known
          puts card[:front]
          puts
          puts card[:back]
          puts
          if card.has_key?(:match)
            until ask_for_match(card[:match])
              next
            end
            puts "Correct."
            puts
          end
        end
        deck.move_first(card[:distance])
        Croupier.save_deck(deck)
      end
    end

    def ask_for_deck
      puts 'Pick a deck:'
      print_decks
      deck = nil
      while deck.nil?
        print '> '
        begin
          id = gets
          raise Interrupt if id.nil?
          id.strip!
          unless id =~ /^[0-9]+$/ && id.to_i >= 0 && id.to_i < Croupier.decks.length
            puts 'Invalid deck id'
            next
          end
          deck = Croupier.load_deck(Croupier.decks[id.to_i])
        rescue InvalidDeck
          puts 'Invalid deck'
        end
      end
      deck
    rescue Interrupt
      print_goodbye
      exit 0
    end

    def ask_for_match(pattern)
      print '> '
      input = gets
      raise Interrupt if input.nil?
      input.strip!
      if pattern =~ /^\/.*\/i?$/
        # Pattern is a regex
        regexp_str, options_str = pattern.match(/^\/(.*)\/(.*)$/)[1, 2]
        options = options_str == 'i' ? Regexp::IGNORECASE : nil
        !!(input.strip =~ Regexp.new(regexp_str, options))
      else
        # Pattern is a plain string
        input == pattern
      end
    rescue Interrupt
      print_goodbye
      exit 0
    end

    def ask_if_known
      known = nil
      while known.nil?
        print 'Do you know this [y/n]? '
        input = gets
        raise Interrupt if input.nil?
        case input.strip.downcase
        when 'y', 'yes' then known = true
        when 'n', 'no'  then known = false
        else puts 'Please say yes or no.'
        end
      end
      known
    rescue Interrupt
      print_goodbye
      exit 0
    end
  end
end
