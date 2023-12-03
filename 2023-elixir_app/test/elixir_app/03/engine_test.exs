defmodule ElixirApp.EngineTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Engine
  alias ElixirApp.FileFixtures

  setup do
    raw_input = FileFixtures.content("03/demo_engine.txt")

    %{raw_input: raw_input}
  end

  describe ".sum_parts" do
    test "returns a sum of parts numbers near symbol", %{raw_input: raw_input} do
      assert 4361 == Engine.sum_parts(raw_input)
    end
  end

  describe ".sum_gears" do
    test "returns a sum of parts numbers near gears", %{raw_input: raw_input} do
      assert 467_835 == Engine.sum_gears(raw_input)
    end
  end

  describe ".load_matrix" do
    test "returns a matrix from raw input" do
      expected = [
        ["1", ".", "3"],
        [".", ".", "6"],
        ["7", "8", "."]
      ]

      raw_input = "1.3\n..6\n78."

      assert expected == Engine.load_matrix(raw_input)
    end
  end

  describe ".build_adjacent_positions" do
    test "returs a row and index of the beginning of adjacent_position" do
      matrix = [
        ["1", "#", "3"],
        ["2", "5", "."],
        ["7", "8", "."]
      ]

      expected = [
        {0, 0},
        {0, 2},
        {1, 0}
      ]

      assert expected == Engine.build_adjacent_positions(matrix)
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("03/engine.txt")

      %{raw_input: raw_input}
    end

    test "returns a sum of parts numbers near symbol", %{raw_input: raw_input} do
      assert 514_969 == Engine.sum_parts(raw_input)
    end

    test "returns a sum of parts numbers near gears", %{raw_input: raw_input} do
      assert 78_915_902 == Engine.sum_gears(raw_input)
    end
  end
end
