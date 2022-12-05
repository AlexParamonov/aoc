defmodule ElixirApp.CraneTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Crane

  setup_all do
    pile = %{1 => [1, 2, 5], 2 => [3, 4]}

    %{pile: pile}
  end

  describe ".sort" do
    test "returns the pile", %{pile: pile} do
      instructions = []

      assert Crane.sort(pile, with: instructions) == %{1 => [1, 2, 5], 2 => [3, 4]}
    end

    test "executes a single instruction", %{pile: pile} do
      instructions = [
        %{from: 1, to: 2, count: 2},
      ]

      assert Crane.sort(pile, with: instructions) == %{1 => [1], 2 => [3, 4, 5, 2]}
    end

    test "executes a list of instructions", %{pile: pile} do
      instructions = [
        %{from: 1, to: 2, count: 2},
        %{from: 2, to: 1, count: 1},
      ]

      assert Crane.sort(pile, with: instructions) == %{1 => [1, 2], 2 => [3, 4, 5]}
    end

    # test "when given out of bounds instructions, it raises an error", %{pile: pile} do
    #   instructions = [
    #     %{from: 3, to: 1, count: 1},
    #   ]

    #   assert_raise RuntimeError, "Invalid instruction", fn ->
    #     Crane.sort(pile, with: instructions)
    #   end
    # end

    test "when invalid instructions, it raises an error", %{pile: pile} do
      instructions = nil

      assert_raise RuntimeError, ~r/instruction/, fn ->
        Crane.sort(pile, with: instructions)
      end
    end
  end

  describe ".sort with 9001 model" do
    test "returns the pile", %{pile: pile} do
      instructions = []

      assert Crane.sort(pile, with: instructions, using: :model_9001) == %{1 => [1, 2, 5], 2 => [3, 4]}
    end

    test "executes a single instruction", %{pile: pile} do
      instructions = [
        %{from: 1, to: 2, count: 2},
      ]

      assert Crane.sort(pile, with: instructions, using: :model_9001) == %{1 => [1], 2 => [3, 4, 2, 5]}
    end

    test "executes a list of instructions", %{pile: pile} do
      instructions = [
        %{from: 1, to: 2, count: 2},
        %{from: 2, to: 1, count: 1},
      ]

      assert Crane.sort(pile, with: instructions, using: :model_9001) == %{1 => [1, 5], 2 => [3, 4, 2]}
    end

    # test "when given out of bounds instructions, it raises an error", %{pile: pile} do
    #   instructions = [
    #     %{from: 3, to: 1, count: 1},
    #   ]

    #   assert_raise RuntimeError, "Invalid instruction", fn ->
    #     Crane.sort(pile, with: instructions)
    #   end
    # end

    test "when invalid instructions, it raises an error", %{pile: pile} do
      instructions = nil

      assert_raise RuntimeError, ~r/instruction/, fn ->
        Crane.sort(pile, with: instructions)
      end
    end
  end
end
