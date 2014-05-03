# encoding: utf-8

module Gaku
  class Card
    SIDE_COLOURS = { front: :bright_blue, back: :bright_yellow }

    def initialize(hash)
      @hash = hash
    end

    def [](key)
      @hash[key]
    end

    def []=(key, value)
      @hash[key] = value
    end

    def key?(key)
      @hash.key?(key)
    end

    def fetch(key, default=nil)
      @hash.fetch(key, default)
    end

    def print(side, canvas)
      unless [:front, :back].include?(side)
        raise ArgumentError, "No such side '#{side}'"
      end
      @hash[side].each_line do |line|
        canvas.print(print_prefix, SIDE_COLOURS[side])
        canvas.puts(line)
      end
    end

    def to_hash
      @hash.dup
    end

    private

    def print_prefix
      CONF.utf8? ? '▌ ' : '| '
    end
  end
end
