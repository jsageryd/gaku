# encoding: utf-8

require 'json'

module Gaku
  class Deck
    attr_reader :name

    # Instantiates a new deck from JSON supplied through +io+.
    def initialize(name, io)
      @name = name
      @deck = read_deck(io)
    end

    # Returns the deck as JSON
    def to_json
      options = {
        indent: '  ',
        space: ' ',
        object_nl: "\n",
        array_nl: "\n",
        allow_nan: true,
        max_nesting: false
      }
      JSON.fast_generate(@deck, options) << "\n"
    end

    # Returns the number of cards in the deck
    def length
      @deck.length
    end

    # Returns the first card
    def first_card
      Card.new(@deck.first)
    end

    # Moves the first card down +distance+ places
    def move_first(distance)
      distance > 0 or raise ArgumentError, 'Distance must be > 0'
      @deck.insert([distance - 1, length - 1].min, @deck.shift)
    end

    # Returns a hash with statistics
    def stats
      stats = {
        card_count: @deck.count,
        seen_count: @deck.count { |c| c.key?(:last_seen) },
        known_count: @deck.count { |c| c[:known] },
        unknown_count: @deck.count { |c| c[:known] == false }
      }
      stats[:unseen_count] = stats[:card_count] - stats[:seen_count]
      stats
    end

    private

    def read_deck(io)
      begin
        JSON.parse(io.read, symbolize_names: true)
      rescue JSON::ParserError => e
        raise Gaku::ParseError, e.message
      end
    end
  end
end
