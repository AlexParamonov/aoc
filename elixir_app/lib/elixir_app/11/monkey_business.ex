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
    monkeys = load_monkeys(raw_input)

    1..rounds
    |> Enum.reduce(monkeys, fn _, monkeys ->
      play_round(monkeys)
    end)
  end

  defp load_monkeys(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&MonkeyLoader.load/1)
    |> Map.new(fn monkey -> {monkey.id, monkey} end)
  end

  defp play_round(monkeys) do
    monkeys
    # monkeys map is recreated on every iteration - cant use the original map
    |> Enum.reduce(monkeys, fn {source_id, _}, monkeys ->
      Map.fetch!(monkeys, source_id)
      |> Monkey.throw_all_items(monkeys)
    end)
  end
end
