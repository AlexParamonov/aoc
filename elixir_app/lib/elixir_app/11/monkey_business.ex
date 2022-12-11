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

  def play(raw_input, rounds: rounds_count) when rounds_count > 50 do
    monkeys = load_monkeys(raw_input)

    common_multiple =
      monkeys
      # |> Enum.map(fn {_id, %{items: items}} -> items end)
      |> Enum.map(&elem(&1, 1).items)
      |> List.flatten()
      |> Enum.reduce(fn item, lcm ->
        Math.lcm(lcm, item)
      end)

    stress_fn = fn item -> rem(item, common_multiple) end

    play_rounds(monkeys, 1..rounds_count, stress_fn)
  end

  def play(raw_input, rounds: rounds_count) do
    stress_fn = fn item -> floor(item / 3) end

    load_monkeys(raw_input)
    |> play_rounds(1..rounds_count, stress_fn)
  end

  defp play_rounds(monkeys, rounds, stress_fn) do
    Enum.reduce(rounds, monkeys, fn _, monkeys ->
      play_round(monkeys, stress_fn)
    end)
  end

  defp load_monkeys(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&MonkeyLoader.load/1)
    |> Map.new(fn monkey -> {monkey.id, monkey} end)
  end

  defp play_round(monkeys, stress_fn) do
    monkeys
    # monkeys map is recreated on every iteration - cant use the original map
    |> Enum.reduce(monkeys, fn {source_id, _}, monkeys ->
      Map.fetch!(monkeys, source_id)
      |> Monkey.throw_all_items(monkeys, stress_fn)
    end)
  end
end
