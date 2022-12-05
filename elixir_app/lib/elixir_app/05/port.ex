defmodule ElixirApp.Port do
  alias ElixirApp.Crane

  def sort_crates(raw_input, using: crane_model) do
    [raw_pile, raw_instructions] =
      raw_input
      |> String.split("\n\n")

    pile = parse_pile(raw_pile)
    instructions = parse_instructions(raw_instructions)

    Crane.sort(pile, with: instructions, using: crane_model)
    |> identify_pile
  end

  defp parse_pile(raw_pile) do
    lines =
      raw_pile
      |> String.split("\n")

    [pile_names | crate_definition] = Enum.reverse(lines)

    crates = parse_crates(crate_definition)
    piles = parse_pile_names(pile_names)

    Enum.zip(piles, crates)
    |> Map.new()
  end

  defp parse_instructions(raw_instructions) do
    raw_instructions
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn instruction ->
      Regex.named_captures(~r/^move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)$/, instruction)
      |> Map.new(fn
        {"count", value} -> {:count, String.to_integer(value)}
        {key, value} -> {String.to_existing_atom(key), value}
      end)
    end)
  end

  defp parse_crates(crates) do
    crates
    |> Enum.map(&String.split(&1, ~r/\s{1,4}/))
    |> Enum.zip()
    |> Enum.map(fn col ->
      col
      |> Tuple.to_list()
      |> Enum.reject(&(&1 == ""))
    end)
  end

  defp parse_pile_names(raw_input) do
    raw_input
    |> String.trim()
    |> String.split()
  end

  defp identify_pile(pile) do
    pile
    |> Enum.map_join(fn {_, crates} ->
      crates
      |> List.last()
      |> String.replace(["[", "]"], "")
    end)
  end
end
