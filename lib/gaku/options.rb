# encoding: utf-8

module Gaku
  class Options
    VALID_OPTIONS = {
      deck: ['-d', '--deck'],
      stats: ['-s', '--stats']
    }

    attr_reader :options

    def initialize(argv)
      @options = {}
      invalid_options = []
      while arg = argv.shift
        if option = arg_hash[arg]
          argument = nil
          unless arg_hash[argv.first]
            argument = argv.shift
          end
          @options[option] = { argument: argument, form: arg }
        else
          invalid_options << arg
        end
      end
      if not invalid_options.empty?
        msg = if invalid_options.length > 1
          "Invalid options #{invalid_options.map { |o| "'#{o}'" }.join(', ')}"
        else
          "Invalid option '#{invalid_options.first}'"
        end
        raise InvalidOption, msg
      end
      ensure_options_valid(@options)
    end

    private

    def ensure_options_valid(options)
      @options.each do |name, option|
        case name
        when :deck then
          unless option[:argument]
            raise InvalidOptionUsage, "#{option[:form]} needs argument"
          end
        end
      end
    end

    def arg_hash
      return @arg_hash if @arg_hash
      @arg_hash = {}
      VALID_OPTIONS.each do |name, forms|
        forms.each { |f| @arg_hash[f] = name }
      end
      @arg_hash
    end
  end
end
