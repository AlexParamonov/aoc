defmodule ElixirApp.Monkey do
  defstruct [:id, :items, :operation_fn, :condition_fn, :inspect_count]
  require Logger

  def throw_all_items(monkey, monkeys) do
    monkey.items
    |> Enum.reduce(monkeys, fn item, monkeys ->
      tampered_item = play_with_item(item, monkey)
      destination_id = pick_destination(tampered_item, monkey)

      monkeys
      |> remove_item(item, monkey.id)
      |> receive_item(tampered_item, destination_id)
    end)
  end

  defp receive_item(monkeys, item, id) do
    Map.update!(monkeys, id, fn %{items: items} = monkey ->
      %{monkey | items: items ++ [item]}
    end)
  end

  defp remove_item(monkeys, _, id) do
    Map.update!(monkeys, id, fn %{items: [_ | items], inspect_count: inspect_count} = monkey ->
      %{monkey | items: items, inspect_count: inspect_count + 1}
    end)
  end

  defp pick_destination(item, monkey) do
    monkey.condition_fn.(item)
  end

  defp play_with_item(item, monkey) do
    item
    |> monkey.operation_fn.()
    |> cool_down()
  end

  defp cool_down(item) do
    (item / 3)
    |> floor()
  end
end
