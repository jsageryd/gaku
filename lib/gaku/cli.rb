# encoding: utf-8

module Gaku
  class CLI
    def initialize(argv)
      @config = Config.new
      exit 1 unless @config.valid?
      puts 'Gaku %s' % [Gaku::VERSION]
    end
  end
end
