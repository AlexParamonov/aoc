# frozen_string_literal: true

require "support/spec_helpers/fixtures"
require "3/backpack"

RSpec.describe RubyApp::Backpack do
  include SpecHelpers::Fixtures

  let(:backpack) { described_class.new(content: input) }
  let(:input) { "vJrwpWtwJgWrhcsFMMfFFhFp" }

  describe ".find_duplicate" do
    let(:subject) { backpack.find_duplicates }

    it { is_expected.to eq(%w[p]) }
  end
end
