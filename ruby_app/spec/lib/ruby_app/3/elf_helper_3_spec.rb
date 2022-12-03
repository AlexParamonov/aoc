require "support/spec_helpers/fixtures"
require "3/elf_helper_3"

RSpec.describe RubyApp::ElfHelper3 do
  include SpecHelpers::Fixtures

  let(:helper) { described_class.new(input) }
  let(:input) { read_fixture("3/demo_backpacks.txt") }

  describe ".find_duplicate_priorities_sum" do
    let(:subject) { helper.find_duplicate_priorities_sum }

    it { is_expected.to eq(157) }
  end

  describe ".find_group_item_priorities_sum" do
    let(:subject) { helper.find_group_item_priorities_sum }

    it { is_expected.to eq(70) }
  end

  describe "solution" do
    let(:input) { read_fixture("3/backpacks.txt") }

    describe ".find_duplicate_priorities_sum" do
      let(:subject) { helper.find_duplicate_priorities_sum }

      it { is_expected.to eq(8_240) }
    end

    describe ".find_group_item_priorities_sum" do
      let(:subject) { helper.find_group_item_priorities_sum }

      it { is_expected.to eq(2_587) }
    end
  end
end
