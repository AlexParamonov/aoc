# frozen_string_literal: true

require "support/spec_helpers/fixtures"
require "01/elf_stash"

RSpec.describe RubyApp::ElfStash do
  include SpecHelpers::Fixtures

  let(:stash) { described_class.new(input, group_size: 3) }
  let(:input) { read_fixture("01/demo_stash.txt") }

  describe ".top_carrier_calories" do
    let(:subject) { stash.top_carrier_calories }

    it { is_expected.to eq(24_000) }
  end

  describe ".top_group_calories" do
    let(:subject) { stash.top_group_calories }

    it { is_expected.to eq(45_000) }
  end

  describe ".top_carrier" do
    let(:subject) { stash.top_carrier }

    it { is_expected.to eq(4) }
  end

  describe ".top_group_carriers" do
    let(:subject) { stash.top_group_carriers }

    it { is_expected.to eq([4, 3, 5]) }
  end

  describe "solution" do
    let(:input) { read_fixture("01/stash.txt") }

    it "finds the top carrier" do
      expect(stash.top_carrier).to eq(189)
    end

    it "finds the top carrier calories" do
      expect(stash.top_carrier_calories).to eq(68_775)
    end

    it "finds the top carrier group" do
      expect(stash.top_group_carriers).to eq([189, 46, 111])
    end

    it "finds the top carrier calories" do
      expect(stash.top_group_calories).to eq(202_585)
    end
  end
end
