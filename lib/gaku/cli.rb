# encoding: utf-8

module Gaku
  class CLI
    def initialize(argv)
      Signal.trap('SIGINT') { quit }
      @options = Options.new(argv).options
      @canvas = Canvas.new(CONF.monochrome?, CONF.utf8?)
      print_banner
      deck_name = @options[:deck] ? @options[:deck][:argument] : nil
      if @options[:stats]
        decks = deck_name ? [Croupier.new(deck_name).deck] : Croupier.deck_names.map { |d| Croupier.new(d).deck }
        print_stats(decks)
      else
        @input = Input.new
        @input.on_quit { quit }
        deck_name ||= ask_for_deck
        @croupier = Croupier.new(deck_name)
        @canvas.puts
        print_deck_info(@croupier.deck)
        @canvas.puts
        quiz
      end
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

    def print_stats(decks)
      decks.each do |deck|
        print_deck_info(deck)
        @canvas.puts
      end
    end

    def print_deck_info(deck)
      s = deck.stats
      pb = BarChart.new(
        [s[:known_count], s[:unknown_count], s[:unseen_count]],
        [:green, :red, :bright_black],
        30,
        @canvas.monochrome?,
        @canvas.utf8? ? '▊' : '#'
      )
      @canvas.puts("#{deck.name}")
      @canvas.print(pb.to_s)
      values = [
        (s[:known_count] * 100) / s[:card_count].to_f,
        s[:known_count],
        s[:card_count]
      ]
      @canvas.puts(' %.0f%% [%d/%d]' % values)
    end

    def print_decks(id_prefix=true)
      Croupier.deck_names.each_with_index do |d, i|
        if id_prefix
          @canvas.puts('  %d) %s' % [i, d])
        else
          @canvas.puts('  %s' % [d])
        end
      end
    end

    def print_victory
      @canvas.puts
      victory_message = Chatter.victory
      @canvas.puts('-' * (victory_message.length + 2), :yellow)
      @canvas.puts(' ' << victory_message << ' ', :bright_yellow)
      @canvas.puts('-' * (victory_message.length + 2), :yellow)
      @victory_announced = true
    end

    def quiz
      loop do
        card = @croupier.card
        card.print(:front, @canvas)
        if card.key?(:match)
          answer = ask_for_string
        else
          answer = ask_if_known
        end
        known = @croupier.answer(answer)
        if !known
          card.print(:back, @canvas)
          if card.key?(:match)
            answer = ask_for_string until @croupier.known?(card, answer)
          end
        else
          print_victory if !@victory_announced && @croupier.deck.all_known?
        end
        @canvas.puts
      end
    end

    def ask_for_deck
      @canvas.puts('Pick a deck:')
      print_decks
      id = nil
      until id =~ /^\d+$/ && (0...Croupier.deck_names.length).cover?(id.to_i)
        id = ask_for_string
      end
      Croupier.deck_names[id.to_i]
    end

    def ask_for_string
      if CONF.monochrome?
        @input.gets('> ')
      else
        @c = Colouring.new
        @input.gets(@c[:bright_black] << '> ' << @c[:reset])
      end
    end

    def ask_if_known
      answer = nil
      while answer.nil?
        case @input.gets('Known [y/n]? ').strip.downcase
        when 'y', 'yes' then answer = true
        when 'n', 'no'  then answer = false
        else @canvas.puts('Please say yes or no.')
        end
      end
      answer
    end
  end
end
