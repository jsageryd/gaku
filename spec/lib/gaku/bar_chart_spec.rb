# encoding: utf-8

require 'gaku/bar_chart'
require 'gaku/colouring'

describe Gaku::BarChart do
  describe '.to_s' do
    context 'given use_colour = true' do
      it 'returns a bar chart with colour' do
        p = Gaku::BarChart.new([1, 2, 3, 4], [:green, :blue, :red], 10, false, '#')
        expect(p.to_s).to eq("\e[0;32m#\e[0m\e[0;34m##\e[0m\e[0;31m###\e[0m\e[0;32m####\e[0m")
      end
    end
    context 'given use_colour = false' do
      it 'returns a monochrome bar chart' do
        p = Gaku::BarChart.new([1, 2, 3, 4], [], 10, true, '#')
        expect(p.to_s).to eq('##########')
      end
    end
  end
end
