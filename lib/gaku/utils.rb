# encoding: utf-8

module Gaku
  module Utils
    class << self
      def remove_trailing_slash(path)
        path.sub(/\/+$/, '')
      end
    end
  end
end
