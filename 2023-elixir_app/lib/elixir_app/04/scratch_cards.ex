defmodule ElixirApp.ScratchCards do
  defmodule Card do
    defstruct [:id, :winning_numbers, :card_numbers]
  end

  def sum_points(raw_input) do
    raw_input
    |> parse_list
    |> load_cards
    |> cards_to_points
    |> Enum.sum()
  end

  defp load_cards(raw_cards) do
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

  defp cards_to_points(cards) do
    cards
    |> Enum.map(&find_winning_numbers/1)
    |> Enum.map(&winning_numbers_to_points/1)
    |> List.flatten()
  end

  defp find_winning_numbers(%Card{winning_numbers: winning_numbers, card_numbers: card_numbers}) do
    lost_numbers = card_numbers -- winning_numbers
    card_numbers -- lost_numbers
  end

  defp winning_numbers_to_points([]), do: 0
  defp winning_numbers_to_points(winning_numbers) do
    2**(Enum.count(winning_numbers) - 1)
  end

  defp load_numbers(raw_numbers) do
    raw_numbers
    |> parse_list(delimeter: "\s")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_list(raw_input, options \\ []) do
    delimeter = Keyword.get(options, :delimeter, "\n")

    raw_input
    |> String.split(delimeter, trim: true)
  end
end
