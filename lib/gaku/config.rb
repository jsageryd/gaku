# encoding: utf-8

module Gaku
  class Config
    attr_accessor :deck_root, :initial_distance
    attr_writer :monochrome, :utf8

    if !ENV['XDG_CONFIG_DIRS'].to_s.empty?
      XDG_CONFIG_DIRS = (ENV['XDG_CONFIG_DIRS'].to_s).split(':').reverse.map do |d|
        Gaku::Utils::remove_trailing_slash(d)
      end
    else
      XDG_CONFIG_DIRS = ['/etc/xdg']
    end

    if !ENV['XDG_CONFIG_HOME'].to_s.empty?
      XDG_CONFIG_HOME = Gaku::Utils::remove_trailing_slash(ENV['XDG_CONFIG_HOME'].to_s)
    else
      XDG_CONFIG_HOME = "#{Dir.home}/.config"
    end

    CONFIG_FILES = [
      File.expand_path('/etc/gaku'),
      XDG_CONFIG_DIRS.map { |d| File.expand_path("#{d}/gaku") },
      File.expand_path("#{Dir.home}/.gaku"),
      File.expand_path("#{XDG_CONFIG_HOME}/gaku"),
    ].flatten

    def initialize
      set_defaults
      CONFIG_FILES.each do |c|
        @c = c
        begin
          instance_eval(File.read(@c)) if File.file?(@c)
        rescue ConfigError
          raise
        rescue StandardError, ScriptError => e
          raise ConfigError, "Configuration is broken (#{@c})\n#{e.message.each_line.map { |l| "  #{l}" }.join}"
        end
      end
    end

    def set_defaults
      @deck_root = File.expand_path(Dir.pwd)
      @initial_distance = 8
      @monochrome = false
      @utf8 = true
    end

    def monochrome?
      !!@monochrome
    end

    def utf8?
      !!@utf8
    end

    def gaku
      @instance ||= self
    end

    def method_missing(name, _)
      raise ConfigError, "Invalid configuration key 'gaku.#{name[/(.*)=$/, 1]}' (#{@c})"
    end
  end
end
