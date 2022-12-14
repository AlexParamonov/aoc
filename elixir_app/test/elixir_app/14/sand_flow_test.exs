defmodule ElixirApp.SandFlowTest do
  use ExUnit.Case, async: true

  alias ElixirApp.SandFlow
  alias ElixirApp.FileFixtures
  # use FlowAssertions

  setup_all do
    raw_input = FileFixtures.content("14/demo_cave.txt")
    %{raw_input: raw_input}
  end

  describe ".sand_units_in_cave_count" do
    test "returns the sum of sand units stuck in a cave", %{raw_input: raw_input} do
      assert SandFlow.sand_units_in_cave_count(raw_input) == 24
    end
  end

  describe ".build_cave" do
    test "builds an example cave", %{raw_input: raw_input} do
      cave = [
        {498, 4},
        {502, 4},
        {503, 4},
        {498, 5},
        {502, 5},
        {496, 6},
        {497, 6},
        {498, 6},
        {502, 6},
        {502, 7},
        {502, 8},
        {494, 9},
        {495, 9},
        {496, 9},
        {497, 9},
        {498, 9},
        {499, 9},
        {500, 9},
        {501, 9},
        {502, 9}
      ]

      assert SandFlow.build_cave(raw_input) == cave
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("14/cave.txt")
      %{raw_input: raw_input}
    end

    test "returns the sum of sand units stuck in a cave", %{raw_input: raw_input} do
      assert SandFlow.sand_units_in_cave_count(raw_input) == 24
    end
  end
end
