# encoding: utf-8

module Gaku
  module Croupier
    class << self
      def decks
        deck_paths.keys
      end

      # Reads named deck, returns Deck instance.
      def load_deck(deck_name)
        File.open(path_for_deck(deck_name), 'r') do |io|
          Deck.new(deck_name, io)
        end
      end

      # Writes Deck instance +deck+ to its file.
      def save_deck(deck)
        File.open(path_for_deck(deck.name), 'w') do |io|
          io.write(deck.to_json)
        end
      end

      private

      def path_for_deck(deck_name)
        begin
          deck_paths.fetch(deck_name)
        rescue KeyError
          raise Gaku::InvalidDeck, "Deck not found '#{deck_name}'"
        end
      end

      def deck_paths
        Hash[
          Dir["#{remove_trailing_slash(File.expand_path(Config.new.deck_root))}/*.deck"].map do |path|
            [path[/([^\/]+).deck$/, 1], File.expand_path(path)]
          end
        ]
      end

      def remove_trailing_slash(path)
        path.sub(/\/+$/, '')
      end
    end
  end
end
