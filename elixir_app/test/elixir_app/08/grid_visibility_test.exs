defmodule ElixirApp.GridVisibilityTest do
  use ExUnit.Case, async: true

  alias ElixirApp.GridVisibility
  alias ElixirApp.FileFixtures

  setup_all do
    raw_input = FileFixtures.content("08/demo_grid.txt")
    %{raw_input: raw_input}
  end

  describe ".count_visible_trees" do
    test "all trees on the edge are visible" do
      raw_input = """
      333
      323
      333
      """

      assert GridVisibility.count_visible_trees(raw_input) == 8
    end

    test "applies horizontal vilibility" do
      [
        """
        333
        123
        333
        """,
        """
        333
        321
        333
        """
      ]
      |> Enum.each(fn input ->
        assert GridVisibility.count_visible_trees(input) == 9
      end)
    end

    test "applies vertical vilibility" do
      [
        """
        313
        323
        333
        """,
        """
        333
        323
        313
        """
      ]
      |> Enum.each(fn input ->
        assert GridVisibility.count_visible_trees(input) == 9
      end)
    end

    test "tallest trees are visible", %{raw_input: raw_input} do
      assert GridVisibility.count_visible_trees(raw_input) == 21
    end
  end

  describe ".visibility_score" do
    test "calculates the visibility score", %{raw_input: raw_input} do
      assert GridVisibility.visibility_score(raw_input) == 8
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("08/grid.txt")
      %{raw_input: raw_input}
    end

    test "tallest trees are visible", %{raw_input: raw_input} do
      assert GridVisibility.count_visible_trees(raw_input) == 1693
    end

    test "calculates the visibility score", %{raw_input: raw_input} do
      assert GridVisibility.visibility_score(raw_input) == 8
    end
  end
end
