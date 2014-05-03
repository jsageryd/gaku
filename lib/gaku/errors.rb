# encoding: utf-8

module Gaku
  class GakuError < StandardError; end
  class ParseError < GakuError; end
  class InvalidDeck < GakuError; end
  class InvalidOption < GakuError; end
  class InvalidOptionUsage < GakuError; end
  class ConfigError < GakuError; end
  class InvalidColour < GakuError; end
end
