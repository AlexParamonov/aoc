defmodule ElixirApp.PathfinderTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Pathfinder
  alias ElixirApp.FileFixtures
  # use FlowAssertions

  setup_all do
    raw_input = FileFixtures.content("12/demo_map.txt")
    %{raw_input: raw_input}
  end

  describe ".shortest_path_step_count" do
    test "finds the count of steps in the shortest path", %{raw_input: raw_input} do
      assert Pathfinder.shortest_path_step_count(raw_input) == 31
    end
  end

  describe ".shortest_path_from_a_step_count" do
    test "finds the count of steps in the shortest paths", %{raw_input: raw_input} do
      assert Pathfinder.shortest_path_from_a_step_count(raw_input) == 29
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("12/map.txt")
      %{raw_input: raw_input}
    end

    test "finds the count of steps in the shortest path", %{raw_input: raw_input} do
      assert Pathfinder.shortest_path_step_count(raw_input) == 420
    end

    test "finds the count of steps in the shortest paths", %{raw_input: raw_input} do
      assert Pathfinder.shortest_path_from_a_step_count(raw_input) == 414
    end
  end
end
