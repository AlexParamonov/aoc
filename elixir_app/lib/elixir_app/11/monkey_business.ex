defmodule ElixirApp.MonkeyBusiness do
  alias ElixirApp.MonkeyLoader
  alias ElixirApp.Monkey
  require Logger

  def calculate_level(raw_input, rounds: rounds) do
    play(raw_input, rounds: rounds)
    |> Enum.map(fn {_, monkey} -> monkey.inspect_count end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(&Kernel.*(&1, &2))
  end

  def play(raw_input, rounds: rounds) do
    monkeys =
      load_monkeys(raw_input)
      |> Map.new(fn monkey -> {monkey.id, monkey} end)

    1..rounds
    |> Enum.reduce(monkeys, fn round, monkeys ->
      Logger.debug("Round #{round}")
      play_round(monkeys)
    end)
  end

  defp load_monkeys(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&MonkeyLoader.load/1)
  end

  defp play_round(monkeys) do
    Map.keys(monkeys)
    |> Enum.reduce(monkeys, fn id, monkeys ->
      {:ok, source_monkey} = Map.fetch(monkeys, id)
      throw_to_another_monkey(source_monkey, id, monkeys)
    end)
  end

  defp throw_to_another_monkey(source_monkey, id, monkeys) do
    source_monkey.items
    |> Enum.reduce(monkeys, fn _, monkeys ->
      {:ok, source_monkey} = Map.fetch(monkeys, id)

      Monkey.pick_item_and_destination(source_monkey)
      |> take_turn(monkeys)
    end)
  end

  defp take_turn(:skip, monkeys), do: monkeys
  defp take_turn(%{item: item, destination: destination, monkey: source_monkey}, monkeys) do
    {:ok, destination_monkey} = Map.fetch(monkeys, destination)
    destination_monkey = Monkey.add_item(item, destination_monkey)

    monkeys
    |> Map.put(source_monkey.id, source_monkey)
    |> Map.put(destination_monkey.id, destination_monkey)
  end
end
