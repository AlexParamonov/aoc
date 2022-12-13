defmodule ElixirApp.SignalValidatorTest do
  use ExUnit.Case, async: true

  alias ElixirApp.SignalValidator
  alias ElixirApp.FileFixtures
  # use FlowAssertions

  setup_all do
    raw_input = FileFixtures.content("13/demo_signals.txt")
    %{raw_input: raw_input}
  end

  describe ".sum_of_valid_signal_ids" do
    test "sums the valid signal ids", %{raw_input: raw_input} do
      assert SignalValidator.sum_of_valid_signal_ids(raw_input) == 13
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("13/signals.txt")
      %{raw_input: raw_input}
    end

    test "sums the valid signal ids", %{raw_input: raw_input} do
      assert SignalValidator.sum_of_valid_signal_ids(raw_input) == 6283
    end
  end
end
