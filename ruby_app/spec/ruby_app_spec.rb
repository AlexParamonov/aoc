# frozen_string_literal: true

RSpec.describe RubyApp do
  let(:subject) { described_class.new }

  it "has a version number" do
    expect(RubyApp::VERSION).not_to be nil
  end

  it "sorts an array" do
    expect(subject.sort([3, 2, 1])).to eq([1, 2, 3])
  end
end
