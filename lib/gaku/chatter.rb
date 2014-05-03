# encoding: utf-8

module Gaku
  module Chatter
    FAREWELL = [
      'All right then o/',
      'Another time then o/',
      'Catch you later o/',
      'Come back soon o/',
      'Farewell o/',
      'Good bye o/',
      'Miss you already o/',
      'Peace out o/',
      'See you soon o/',
      'So long o/',
      'Take care o/',
      'Tata o/',
      'Todilo o/'
    ]

    class << self
      def method_missing(name)
        const_get(name.upcase).sample
      end
    end
  end
end
