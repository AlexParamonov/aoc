defmodule ElixirApp.ScratchCardCore.CardRules do
  alias ElixirApp.ScratchCardCore.Card

  defmodule WinningCard do
    defstruct [:id, :value, :duplicate_count]
  end

  def cards_won(winning_cards, %Card{} = card) do
    current_card =
      Enum.find(winning_cards, fn {id, _} -> id == card.id end)
      |> update_card_value(card)

    current_card
    |> put_card_in_winning_cards(winning_cards)
    |> duplicate_cards(current_card)
  end

  def count_cards(winning_cards) do
    winning_cards
    |> Enum.reduce(0, fn {_, {_, duplicate_count}}, acc ->
      acc + duplicate_count
    end)
  end

  defp update_card_value({id, {_, duplicate_count}}, card) do
    value =
      card
      |> find_winning_numbers()
      |> length()

    {id, {value, duplicate_count}}
  end

  defp put_card_in_winning_cards({card_id, _} = card, winning_cards) do
    winning_cards
    |> Enum.map(fn
      {^card_id, _} -> card
      x -> x
    end)
  end

  defp find_winning_numbers(%Card{winning_numbers: winning_numbers, card_numbers: card_numbers}) do
    lost_numbers = card_numbers -- winning_numbers
    card_numbers -- lost_numbers
  end

  defp duplicate_cards(card_list, {card_id, card_data}) do
    duplicate_card(card_list, card_id, card_data)
  end

  defp duplicate_card(card_list, _card_id, {0, _}) do
    card_list
  end

  defp duplicate_card(card_list, card_id, {value, duplicate_count}) do
    id_to_duplicate = card_id + 1

    card_list
    |> Enum.map(fn
      {^id_to_duplicate, {v, d}} -> {id_to_duplicate, {v, d + duplicate_count}}
      x -> x
    end)
    |> duplicate_card(id_to_duplicate, {value - 1, duplicate_count})
  end
end
