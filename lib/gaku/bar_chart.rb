# encoding: utf-8

module Gaku
  class BarChart
    def initialize(values, colours, width, monochrome, step_char='▊')
      @values = values
      @colours = colours
      @width = width
      @step_char = step_char
      if @use_colour = !monochrome && colours && colours.length > 0
        @c = Colouring.new
      end
    end

    def to_s
      sum = @values.inject(0) { |sum, element| sum + element }
      step = (@width * 1.0) / sum
      str = ''
      @values.each_with_index do |v, i|
        str << @c[colour(i)] if @use_colour
        str << @step_char * (step * v).round
        str << @c[:reset] if @use_colour
      end
      "#{str}"
    end

    private

    def colour(index)
      @colours[index % @colours.length]
    end
  end
end
