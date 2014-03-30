# encoding: utf-8

require 'gaku/options'
require 'gaku/errors'

describe Gaku::Options do
  describe '.new' do
    it 'correctly parses given args' do
      o = Gaku::Options.new(%w{-d deck --stats})
      expect(o.options).to eq(
        {
          deck: { argument: 'deck', form: '-d' },
          stats: {argument: nil, form: '--stats' }
        }
      )
    end

    context 'when given an invalid option'
      it 'raises Gaku::InvalidOption' do
        expect {
          Gaku::Options.new(['--invalid'])
        }.to raise_error(Gaku::InvalidOption)
      end
  end
end
