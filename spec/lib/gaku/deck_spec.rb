# encoding: utf-8

require 'gaku/deck'
require 'json'

describe Gaku::Deck do
  let(:test_deck) do
    [
      {
        front: 'First front',
        back:  'First back'
      },
      {
        front: 'Second front',
        back:  'Second back'
      },
      {
        front: 'Third front',
        back:  'Third back'
      }
    ]
  end

  let(:test_deck_json) do
    <<-JSON
[
  {
    "front": "First front",
    "back": "First back"
  },
  {
    "front": "Second front",
    "back": "Second back"
  },
  {
    "front": "Third front",
    "back": "Third back"
  }
]
    JSON
  end

  subject { Gaku::Deck.new(:test_deck, StringIO.new(test_deck.to_json)) }

  describe '#to_json' do
    it 'returns the deck as pretty JSON' do
      expect(subject.to_json).to eq(test_deck_json)
    end
  end

  describe '#length' do
    it 'returns the number of cards in the deck' do
      expect(subject.length).to eq(test_deck.length)
    end
  end

  describe '#first_card' do
    it 'returns the first card' do
      expect(subject.first_card).to eq(test_deck.first)
    end
  end

  describe '#name' do
    it 'returns the name of the deck' do
      expect(subject.name).to eq(:test_deck)
    end
  end

  describe '#move_first' do
    it 'moves the first card down specified number of places' do
      expect {
        subject.move_first(1)
      }.to change { subject.instance_variable_get(:@deck) }.from(
        [
          {
            front: 'First front',
            back:  'First back'
          },
          {
            front: 'Second front',
            back:  'Second back'
          },
          {
            front: 'Third front',
            back:  'Third back'
          }
        ]
      ).to(
        [
          {
            front: 'Second front',
            back:  'Second back'
          },
          {
            front: 'First front',
            back:  'First back'
          },
          {
            front: 'Third front',
            back:  'Third back'
          }
        ]
      )
    end

    it 'raises ArgumentError if argument is not > 0' do
      expect { subject.move_first(0) }.to raise_error(ArgumentError)
    end
  end
end
