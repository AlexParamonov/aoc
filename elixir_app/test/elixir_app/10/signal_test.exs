defmodule ElixirApp.SignalTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Signal
  alias ElixirApp.FileFixtures

  setup_all do
    raw_input = FileFixtures.content("10/demo_signal.txt")
    %{raw_input: raw_input}
  end

  describe ".sum_signal_on_milestones" do
    test "returns a number of uniq positions on a grid tail visited", %{raw_input: raw_input} do
      assert Signal.sum_signal_on_milestones(raw_input, milestones: [20, 60, 100, 140, 180, 220]) == 13_140
    end
  end

  describe "tail movement logic" do
    [
      {20, 21, 420},
      {60, 19, 1140},
      {100, 18, 1800},
      {140, 21, 2940},
      {180, 16, 2880},
      {220, 18, 3960},
    ]
    |> Enum.each(fn {milestone, x, signal} ->
      test "signal on milestone: #{milestone}", %{raw_input: raw_input} do
        assert Signal.report_signal(raw_input, unquote(milestone)) == {unquote(milestone), unquote(x), unquote(signal)}
      end
    end)

    test "mini example" do
      raw_input =
        """
        noop
        addx 3
        addx -5
        """
    assert Signal.milestones(raw_input) == [{0, 1}, {1, 1}, {2, 1}, {3, 1}, {4, 4}, {5, 4}]
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("10/signal.txt")
      %{raw_input: raw_input}
    end

    test "returns a number of uniq positions on a grid tail visited", %{raw_input: raw_input} do
      assert Signal.sum_signal_on_milestones(raw_input, milestones: [20, 60, 100, 140, 180, 220]) == 10_760
    end
  end
end
