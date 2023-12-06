defmodule ElixirApp.RaceTest do
  use ExUnit.Case, async: true
  use FlowAssertions

  alias ElixirApp.Race
  alias ElixirApp.FileFixtures

  setup do
    raw_input = FileFixtures.content("06/demo_race.txt")

    %{raw_input: raw_input}
  end

  describe ".ways_to_win_power" do
    test "returns the multiplication of ways to win all races", %{raw_input: raw_input} do
      assert 288 == Race.ways_to_win_power(raw_input)
    end
  end

  describe ".ways_to_win_long_race_power" do
    test "returns the multiplication of ways to win long race", %{raw_input: raw_input} do
      assert 71_503 == Race.ways_to_win_long_race_power(raw_input)
    end
  end

  describe ".ways_to_win" do
    test "returns a number of ways to win a game" do
      assert 4 == Race.ways_to_win({7, 9})
      assert 8 == Race.ways_to_win({15, 40})
      assert 9 == Race.ways_to_win({30, 200})
    end

  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("06/race.txt")
      %{raw_input: raw_input}
    end

    test "returns the multiplication of ways to win all races", %{raw_input: raw_input} do
      assert 227_850 == Race.ways_to_win_power(raw_input)
    end

    test "returns the multiplication of ways to win long race", %{raw_input: raw_input} do
      assert 71_503 == Race.ways_to_win_long_race_power(raw_input)
    end
  end
end
