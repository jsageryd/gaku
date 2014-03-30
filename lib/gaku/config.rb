# encoding: utf-8

module Gaku
  class Config
    attr_accessor :deck_root, :initial_distance

    CONFIG_FILE = File.expand_path("#{Dir.home}/.gaku")

    def initialize
      set_defaults
      instance_eval(File.read(CONFIG_FILE)) if File.exists?(CONFIG_FILE)
    end

    def set_defaults
      @deck_root = File.expand_path(Dir.pwd)
      @initial_distance = 8
    end

    def gaku
      @instance ||= self
    end

    def method_missing(name, _)
      raise ConfigError, "Invalid configuration key 'gaku.#{name[/(.*)=$/, 1]}' (#{CONFIG_FILE})"
    end
  end
end
