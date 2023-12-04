defmodule ElixirApp.CardStack do
  alias ElixirApp.ScratchCardCore.CardLoader
  alias ElixirApp.ScratchCardCore.CardRules
  alias ElixirApp.ScratchCardBoundary.CardStackServer

  # TODO: use registry
  def sum_cards(raw_input) do
    raw_input
    |> parse_list
    |> CardLoader.from_list()
    |> load_stack_to_server
    |> use_cards

    CardRules.count_cards(CardStackServer.winning_cards())
  end

  defp load_stack_to_server(cards) do
    CardStackServer.load_cards(cards)
  end

  defp use_cards(cards) do
    cards
    |> Enum.each(&CardStackServer.use_card/1)
  end

  defp parse_list(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
  end
end
