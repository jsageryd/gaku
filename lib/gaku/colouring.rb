# encoding: utf-8

module Gaku
  class Colouring
    def [](value)
      case value
      when :reset          then colour('0');
      when :black          then colour('0;30')
      when :red            then colour('0;31')
      when :green          then colour('0;32')
      when :yellow         then colour('0;33')
      when :blue           then colour('0;34')
      when :magenta        then colour('0;35')
      when :cyan           then colour('0;36')
      when :white          then colour('0;37')
      when :bright_black   then colour('1;30')
      when :bright_red     then colour('1;31')
      when :bright_green   then colour('1;32')
      when :bright_yellow  then colour('1;33')
      when :bright_blue    then colour('1;34')
      when :bright_magenta then colour('1;35')
      when :bright_cyan    then colour('1;36')
      when :bright_white   then colour('1;37')
      else raise InvalidColour, "Invalid colour '#{value}'"
      end
    end

    private

    def colour(colour)
      "\e[#{colour}m"
    end
  end
end
