# encoding: utf-8

module Gaku
  class Croupier
    class << self
      def deck_names
        deck_paths.keys
      end

      def deck_paths
        @deck_paths ||= Hash[
          Dir["#{remove_trailing_slash(File.expand_path(CONF.deck_root))}/*.deck"].map do |path|
            [path[/([^\/]+).deck$/, 1], File.expand_path(path)]
          end
        ]
      end

      private

      def remove_trailing_slash(path)
        path.sub(/\/+$/, '')
      end
    end

    attr_reader :deck

    def initialize(deck_name)
      @deck = load_deck(deck_name)
    end

    def card
      @deck.first_card
    end

    def answer(answer)
      c = card
      now = Time.now.to_i
      c[:first_seen] ||= now
      c[:last_seen] = now
      c[:seen_count] ||= 0
      c[:seen_count] += 1
      distance = c.fetch(:distance, CONF.initial_distance)
      if known = known?(c, answer)
        c[:last_known] = now
        c[:known] = true
        distance *= 2
      else
        c[:known] = false
        distance /= 2
      end
      c[:distance] =
        case
        when distance < 2 then 2
        when distance > deck.length then 2 ** Math.log2(deck.length).ceil
        else distance
        end
      @deck.move_first(c[:distance])
      save_deck
      known
    end

    def known?(card, answer)
      if card.key?(:match)
        pattern = card[:match]
        if pattern =~ %r{^/.*/i?$}
          regexp_str, options_str = pattern.match(%r{^/(.*)/(.*)$})[1, 2]
          options = options_str == 'i' ? Regexp::IGNORECASE : nil
          !!(answer.strip =~ Regexp.new(regexp_str, options))
        else
          answer == pattern
        end
      elsif [true, false].include?(answer)
        answer
      end
    end

    private

    # Reads named deck, returns Deck instance.
    def load_deck(deck_name)
      File.open(path_for_deck(deck_name), 'r') do |io|
        Deck.new(deck_name, io)
      end
    end

    # Writes Deck instance +deck+ to its file.
    def save_deck
      return unless @deck.modified?
      File.open(path_for_deck(@deck.name), 'w') do |io|
        io.write(@deck.to_json)
        @deck.set_unmodified
      end
    end

    def path_for_deck(deck_name)
      begin
        self.class.deck_paths.fetch(deck_name)
      rescue KeyError
        raise Gaku::InvalidDeck, "Deck not found '#{deck_name}'"
      end
    end
  end
end
