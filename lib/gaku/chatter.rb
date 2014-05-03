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

    DEATH = [
      'Adieu, mes amis. Je vais la gloire.',
      'All is lost.',
      'Beautiful.',
      'Drink to me!',
      'Get my swan costume ready.',
      'I am about to -- or I am going to -- die: either expression is correct.',
      'I am ready.',
      'I die.',
      'I have tried so hard to do right.',
      'I see black light.',
      'It is very beautiful over there.',
      'Josephine...',
      'Now comes the mystery.',
      'Why not? Yeah.'
    ]

    VICTORY = [
      '\(^o^)/ You seem to know ALL cards.'
    ]

    class << self
      def method_missing(name)
        const_get(name.upcase).sample
      end
    end
  end
end
