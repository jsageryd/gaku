# encoding: utf-8

module Gaku
  class Input
    def initialize(io=STDIN)
      if io == STDIN && io.tty?
        @readline = true
        require 'readline'
        Readline.completion_proc = proc {}
      end
      @io = io
    end

    def gets(prompt=nil)
      got =
        if @readline then
          Readline.readline(prompt)
        else
          print prompt
          @io.gets.chomp
        end
      if got.nil? && @on_quit
        @on_quit.call
      end
      got
    end

    def on_quit(&block)
      @on_quit = block
    end
  end
end
