defmodule ElixirApp.ScratchCardCore.CardLoader do
  alias ElixirApp.ScratchCardCore.Card

  def from_list(raw_cards) do
    raw_cards
    |> Enum.map(&load_card/1)
  end

  defp load_card(raw_card) do
    data = Regex.named_captures(~r/\ACard\s+(?<id>\d+): (?<raw_winning_numbers>.+?) \| (?<raw_card_numbers>.+)\z/, raw_card)

    %Card{
      id: String.to_integer(data["id"]),
      winning_numbers: load_numbers(data["raw_winning_numbers"]),
      card_numbers: load_numbers(data["raw_card_numbers"]),
    }
  end

  defp load_numbers(raw_numbers) do
    raw_numbers
    |> parse_list(delimeter: "\s")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_list(raw_input, delimeter: delimeter) do
    raw_input
    |> String.split(delimeter, trim: true)
  end
end
