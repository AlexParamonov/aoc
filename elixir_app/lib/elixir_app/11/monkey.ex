defmodule ElixirApp.Monkey do
  defstruct [:id, :items, :operation_fn, :condition_fn, :inspect_count]
  require Logger

  def pick_item_and_destination(%{items: []}) do
    :skip
  end

  def pick_item_and_destination(%{items: [item | items]} = monkey) do
    # Logger.warn("Monkey #{monkey.id} picked item #{item}")
    item = play_with_item(item, monkey)
    destination = pick_destination(item, monkey)

    monkey = %{monkey | items: items, inspect_count: monkey.inspect_count + 1}

    # Logger.warn("Monkey #{monkey.id} throwed item #{item} to destination #{destination}")
    %{
      item: item,
      destination: destination,
      monkey: monkey
    }
  end

  def add_item(item, %{items: items} = monkey) do
    # Logger.warn("Monkey #{monkey.id} got item #{item}")
    %{monkey | items: items ++ [item]}
  end

  defp pick_destination(item, monkey) do
    monkey.condition_fn.(item)
  end

  defp play_with_item(item, monkey) do
    item
    |> monkey.operation_fn.()
    # |> cool_down()
  end

  defp cool_down(item) do
    (item / 3)
    |> floor()
  end
end
