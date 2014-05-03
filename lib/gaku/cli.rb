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
      deck_name ||= ask_for_deck
      @croupier = Croupier.new(deck_name)
      @canvas.puts
      @canvas.puts("Deck '#{@croupier.deck.name}' loaded.")
      @canvas.puts
      quiz
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
      Croupier.deck_names.each_with_index do |d, i|
        if id_prefix
          @canvas.puts('  %d) %s' % [i, d])
        else
          @canvas.puts('  %s' % [d])
        end
      end
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
