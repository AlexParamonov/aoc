defmodule ElixirApp.RopeMovementTest do
  use ExUnit.Case, async: true

  alias ElixirApp.RopeMovement
  alias ElixirApp.FileFixtures

  setup_all do
    raw_input = FileFixtures.content("09/demo_movement.txt")
    %{raw_input: raw_input}
  end

  describe ".count_uniq_tail_positions" do
    test "returns a number of uniq positions on a grid tail visited", %{raw_input: raw_input} do
      assert RopeMovement.count_uniq_tail_positions(raw_input) == 13
    end
  end

  describe "tail movement logic" do
    [
      {{0, 0}, "top left"},
      {{0, 1}, "top"},
      {{0, 2}, "top right"},
      {{1, 2}, "right"},
      {{2, 2}, "bottom right"},
      {{2, 1}, "bottom"},
      {{2, 0}, "bottom left"},
      {{1, 0}, "left"},
      {{1, 1}, "center"}
    ]
    |> Enum.each(fn {tail, location} ->
      test "does not move when touching the head on #{location}" do
        assert RopeMovement.move_tail(head: {1, 1}, tail: unquote(tail)) == unquote(tail)
      end
    end)

    test "moves towards head when in the same row" do
      assert RopeMovement.move_tail(head: {0, 2}, tail: {0, 0}) == {0, 1}
      assert RopeMovement.move_tail(head: {5, 5}, tail: {5, 2}) == {5, 3}
    end

    test "moves towards head when in the same col" do
      assert RopeMovement.move_tail(head: {0, 0}, tail: {2, 0}) == {1, 0}
      assert RopeMovement.move_tail(head: {5, 5}, tail: {2, 5}) == {3, 5}
    end

    test "moves towards head diagonally" do
      assert RopeMovement.move_tail(head: {0, 0}, tail: {2, 2}) == {1, 1}
      assert RopeMovement.move_tail(head: {5, 5}, tail: {2, 3}) == {3, 4}
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("09/movement.txt")
      %{raw_input: raw_input}
    end

    test "returns a number of uniq positions on a grid tail visited", %{raw_input: raw_input} do
      assert RopeMovement.count_uniq_tail_positions(raw_input) == 6314
    end
  end
end
