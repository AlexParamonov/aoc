defmodule ElixirApp.Almanac do
  @map_order [
    "seed-to-soil",
    "soil-to-fertilizer",
    "fertilizer-to-water",
    "water-to-light",
    "light-to-temperature",
    "temperature-to-humidity",
    "humidity-to-location"
  ]

  def load(raw_input) do
    [raw_seed_list | raw_maps] =
      raw_input
      |> parse_list(delimeter: "\n\n")

    seeds = load_seeds(raw_seed_list)
            |> Enum.map(fn seed -> seed..seed end)
    maps = load_maps(raw_maps)

    {seeds, maps}
  end

  def load_seed_range(raw_input) do
    [raw_seed_list | raw_maps] =
      raw_input
      |> parse_list(delimeter: "\n\n")

    seeds = load_seed_ranges(raw_seed_list)
    maps = load_maps(raw_maps)

    {seeds, maps}
  end

  def min_location({seeds, maps}) do
    seeds
    |> find_location(maps)
    |> Enum.map(fn first.._last -> first end)
    |> Enum.min()
  end

  defp find_location(seeds, maps) do
    @map_order
    |> Enum.reduce(seeds, fn map_name, acc ->
      map = Map.get(maps, map_name)

      acc =
        acc
        |> Enum.map(fn range ->
          apply_range_transformation(range, map)
        end)
        |> List.flatten()
    end)
  end

  def apply_range_transformation(first..last = range, transformation) when last < first do
    transformation
    |> Enum.map(fn
      [destination_start, source_start, range_length] ->
        source_end = source_start + range_length - 1
        shift_amount = destination_start - source_start

        cond do
          first in source_start..source_end ->
            transform_range(first..first, shift_amount)
          true -> nil
        end
    end)
    |> Enum.uniq
    |> maybe_inject_range(range)
    |> Enum.reject(&is_nil/1)
  end

  def apply_range_transformation(first..last = range, transformation) do
    transformation
    |> Enum.map(fn
      [destination_start, source_start, range_length] ->
        source_end = source_start + range_length - 1
        shift_amount = destination_start - source_start

        # dbg({range, source_start..source_end})

        cond do
          source_start in range ->
            apply_range_transformation(first..(source_start - 1), transformation) ++
              if source_end >= last do
                transform_range(source_start..last, shift_amount)
              else
                transform_range(source_start..source_end, shift_amount) ++
                  apply_range_transformation((source_end + 1)..last, transformation)
              end

          source_end in range ->
            transform_range(first..source_end, shift_amount) ++
              apply_range_transformation((source_end + 1)..last, transformation)

          first in source_start..source_end ->
            transform_range(first..last, shift_amount)

          true ->
            nil
        end
    end)
    |> Enum.uniq
    |> maybe_inject_range(range)
    |> Enum.reject(&is_nil/1)
  end

  defp maybe_inject_range([nil], range), do: [range]
  defp maybe_inject_range(list, _range), do: list

  defp transform_range(range, shift_amount) do
    [Range.shift(range, shift_amount)]
  end

  def apply_transformation(number, transformation) do
    clauses =
      transformation
      |> Enum.map(fn
        [destination_start, source_start, range_length] ->
          # Case
          # {:->, [],
          #  [
          #    [
          #      {:when, [], [number, {:in, [], [number, Macro.escape(source_start..(source_start + range_length))]}]}
          #    ],
          #    destination_start + (number - source_start)
          #  ]}

          # Cond
          {:->, [],
           [
             [
               {:in, [], [number, Macro.escape(source_start..(source_start + range_length))]}
             ],
             destination_start + (number - source_start)
           ]}
      end)

    clauses =
      clauses ++
        [
          {:->, [], [[true], number]}
          # {:->, [], [[{:_, [], Elixir}], number]}
        ]

    Code.eval_quoted(
      quote do
        cond do
          unquote(clauses)
        end
      end
    )
    |> elem(0)
  end

  defp load_seed_ranges(raw_seed_list) do
    raw_seed_list
    |> parse_list(delimeter: " ")
    |> Enum.slice(1..-1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [start, length] -> start..(start + length - 1) end)

    # |> Enum.flat_map(&Range.to_list/1)
  end

  defp load_seeds(raw_seed_list) do
    raw_seed_list
    |> parse_list(delimeter: " ")
    |> Enum.slice(1..-1)
    |> Enum.map(&String.to_integer/1)
  end

  defp load_maps(raw_maps) do
    raw_maps
    |> Enum.map(&load_map_element/1)
    |> Enum.into(%{})
  end

  defp load_map_element(raw_map) do
    [[map_name, _] | map_data] =
      raw_map
      |> parse_list(delimeter: "\n")
      |> Enum.map(&parse_list(&1, delimeter: " "))

    map_data =
      map_data
      |> Enum.map(fn list ->
        list
        |> Enum.map(&String.to_integer/1)
      end)

    {map_name, map_data}
  end

  defp parse_list(raw_input, delimeter: delimeter) do
    raw_input
    |> String.split(delimeter, trim: true)
  end
end
