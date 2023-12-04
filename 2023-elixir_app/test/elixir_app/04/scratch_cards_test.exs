defmodule ElixirApp.ScratchCardsTest do
  use ExUnit.Case, async: true

  alias ElixirApp.ScratchCards
  alias ElixirApp.FileFixtures

  setup do
    raw_input = FileFixtures.content("04/demo_cards.txt")

    %{raw_input: raw_input}
  end

  describe ".sum_points" do
    test "returns a sum of winning points on all cards", %{raw_input: raw_input} do
      assert 13 == ScratchCards.sum_points(raw_input)
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("04/cards.txt")

      %{raw_input: raw_input}
    end

    test "returns a sum of winning points on all cards", %{raw_input: raw_input} do
      assert 17803 == ScratchCards.sum_points(raw_input)
    end
  end
end
