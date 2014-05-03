# encoding: utf-8

module Gaku
  class Canvas
    def initialize(monochrome, utf8)
      @monochrome = !!monochrome
      @utf8 = !!utf8
      @c = Gaku::Colouring.new
    end

    def monochrome?
      @monochrome
    end

    def puts(text=nil, colour=nil)
      print(text.chomp, colour) if text
      STDOUT.puts
    end

    def print(text=nil, colour=nil)
      if monochrome? || colour.nil?
        STDOUT.print(text)
      else
        STDOUT.print('%s%s%s' % [@c[colour], text, @c[:reset]])
      end
    end

    def utf8?
      @utf8
    end
  end
end
