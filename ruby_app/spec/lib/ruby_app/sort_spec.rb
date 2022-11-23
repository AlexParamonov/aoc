# frozen_string_literal: true

require "ruby_app/sort"

RSpec.describe RubyApp::Sort do
  let(:sorter) { described_class.new(input) }

  describe ".sort" do
    let(:input) { [3, 2, 1] }
    let(:subject) { sorter.sort }

    it { is_expected.to eq([1, 2, 3]) }
  end
end
