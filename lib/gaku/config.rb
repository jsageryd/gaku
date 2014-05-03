# encoding: utf-8

module Gaku
  class Config
    attr_accessor :deck_root, :initial_distance
    attr_writer :monochrome, :utf8

    def monochrome?
      !!@monochrome
    end

    def utf8?
      !!@utf8
    end

    CONFIG_FILE = File.expand_path("#{Dir.home}/.gaku")

    def initialize
      set_defaults
      begin
        instance_eval(File.read(CONFIG_FILE)) if File.exists?(CONFIG_FILE)
      rescue ConfigError
        raise
      rescue StandardError => e
        raise ConfigError, "Configuration is broken (#{CONFIG_FILE})"
      end
    end

    def set_defaults
      @deck_root = File.expand_path(Dir.pwd)
      @initial_distance = 8
      @monochrome = false
      @utf8 = true
    end

    def gaku
      @instance ||= self
    end

    def method_missing(name, _)
      raise ConfigError, "Invalid configuration key 'gaku.#{name[/(.*)=$/, 1]}' (#{CONFIG_FILE})"
    end
  end
end
