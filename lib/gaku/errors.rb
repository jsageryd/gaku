# encoding: utf-8

module Gaku
  class GakuError < StandardError; end
  class ParseError < GakuError; end
  class InvalidDeck < GakuError; end
end
