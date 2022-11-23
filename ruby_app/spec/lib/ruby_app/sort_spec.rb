# frozen_string_literal: true

require "ruby_app/sort"

RSpec.describe RubyApp::Sort do
  let(:subject) { described_class }

  it "sorts an array" do
    expect(subject.new([3, 2, 1]).sort).to eq([1, 2, 3])
  end
end
