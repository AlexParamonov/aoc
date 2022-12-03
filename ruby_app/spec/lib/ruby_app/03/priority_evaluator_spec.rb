require "support/spec_helpers/fixtures"
require "03/priority_evaluator"

RSpec.describe RubyApp::PriorityEvaluator do
  include SpecHelpers::Fixtures

  describe ".evaluate" do
    {
      "p" => 16,
      "L" => 38,
      "P" => 42,
      "v" => 22,
      "t" => 20,
      "s" => 19
    }.each do |item, expected|
      it "evaluates priority for #{item}" do
        expect(described_class.new(item).evaluate).to eq expected
      end
    end

    it "raises for unknown items" do
      expect { described_class.new("/").evaluate }.to raise_error(ArgumentError)
    end
  end
end
