defmodule ElixirApp.CardStackTest do
  use ExUnit.Case, async: true

  alias ElixirApp.CardStack
  alias ElixirApp.FileFixtures
  alias ElixirApp.ScratchCardBoundary.CardStackServer

  setup do
    raw_input = FileFixtures.content("04/demo_cards.txt")
    {:ok, _pid} = start_supervised(CardStackServer)
    %{raw_input: raw_input}
  end

  describe ".sum_cards" do
    test "returns a total sum of scratchcards after duplication", %{raw_input: raw_input} do
      assert 30 == CardStack.sum_cards(raw_input)
    end
  end
end
