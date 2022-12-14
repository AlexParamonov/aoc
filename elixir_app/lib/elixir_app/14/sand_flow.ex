defmodule ElixirApp.SandFlow do
  require Logger

  def sand_units_in_cave_count(raw_cave) do
    cave = build_cave(raw_cave)

    cave
    |> fill_cave(start: {500, 0})
    |> count_sand_units(cave)
  end

  defp count_sand_units(cave, original_cave) do
    Enum.count(cave) - Enum.count(original_cave)
  end

  defp fill_cave(cave, start: source_location) do
    cave
    |> find_impact_point(source_location)
    |> find_landing_location
    |> case do
      :out_of_bounds -> cave
      landing_location -> fill_cave([landing_location | cave], start: source_location)
    end
  end

  defp find_landing_location({_cave, {_x, 200}}) do
    :out_of_bounds
  end

  defp find_landing_location({cave, {impact_x, impact_y}}) do
    Logger.debug("Impact point: #{impact_x}, #{impact_y}")
    possible_location_left = {impact_x - 1, impact_y}
    possible_location_right = {impact_x + 1, impact_y}

    if Enum.member?(cave, possible_location_left) and Enum.member?(cave, possible_location_right) do
      {impact_x, impact_y - 1}
    else
      if not Enum.member?(cave, possible_location_left) do
        find_impact_point(cave, {impact_x - 1, impact_y})
        |> find_landing_location
      else
        find_impact_point(cave, {impact_x + 1, impact_y})
        |> find_landing_location
      end
    end
  end

  defp find_impact_point(cave, {source_x, source_y}) do
    impact_y =
      Stream.take_while(source_y..199, fn y ->
        not Enum.member?(cave, {source_x, y})
      end)
      |> Enum.to_list()
      |> List.last()

    {cave, {source_x, impact_y + 1}}
  end

  defp count_sand_units(cave) do
    0
  end

  def build_cave(raw_cave) do
    raw_cave
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&load_line/1)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort_by(&[elem(&1, 1), elem(&1, 0)], :asc)
  end

  defp load_line(line) do
    line
    |> String.split(" -> ")
    |> Enum.map(&load_coordinate/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(&fill_between_rocks/1)
  end

  defp load_coordinate(str_coordinate) do
    str_coordinate
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp fill_between_rocks([start, finish]) when start == finish do
    [start]
  end

  defp fill_between_rocks([{start_x, start_y}, {finish_x, finish_y}]) when start_x == finish_x do
    Enum.map(start_y..finish_y, fn y -> {start_x, y} end)
  end

  defp fill_between_rocks([{start_x, start_y}, {finish_x, finish_y}]) when start_y == finish_y do
    Enum.map(start_x..finish_x, fn x -> {x, start_y} end)
  end
end
