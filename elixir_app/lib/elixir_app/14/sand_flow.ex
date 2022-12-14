defmodule ElixirApp.SandFlow do
  require Logger

  def sand_units_in_cave_count(raw_cave) do
    cave = build_cave(raw_cave)

    cave
    |> fill_cave(start: {500, 0}, max: 200)
    |> count_sand_units(cave)
  end

  def sand_units_in_cave_with_bottom_count(raw_cave) do
    cave = build_cave(raw_cave)

    max =
      cave
      |> Enum.max_by(&elem(&1, 1))
      |> elem(1)
      |> Kernel.+(2)

    cave
    |> fill_cave(start: {500, 0}, max: max)
    |> count_sand_units(cave)
  end

  defp count_sand_units(cave, original_cave) do
    Enum.count(cave) - Enum.count(original_cave)
  end

  defp fill_cave(cave, start: source_location, max: max) do
    cave
    |> find_impact_point(source_location, max)
    |> find_landing_location
    |> case do
      :out_of_bounds -> cave
      landing_location -> fill_cave([landing_location | cave], start: source_location, max: max)
    end
  end

  defp find_landing_location({_cave, {_x, 200}, _max}) do
    :out_of_bounds
  end

  defp find_landing_location({_cave, {_x, 0}, _max}) do
    :out_of_bounds
  end


  # defp find_landing_location({cave, {impact_x, impact_y}, max}) when max + 1 == impact_y do
  #   Logger.debug("Impact point: #{impact_x}, #{impact_y}")
  #   :out_of_bounds
  # end

  defp find_landing_location({cave, {impact_x, impact_y}, max}) do
    # Logger.debug("Impact point: #{impact_x}, #{impact_y}, max: #{max}")
    possible_location_left = {impact_x - 1, impact_y}
    possible_location_right = {impact_x + 1, impact_y}

    if filled?(cave, possible_location_left, max) do
      if filled?(cave, possible_location_right, max) do
        {impact_x, impact_y - 1}
      else
        find_impact_point(cave, possible_location_right, max)
        |> find_landing_location
      end
    else
      find_impact_point(cave, possible_location_left, max)
      |> find_landing_location
    end
  end

  defp filled?(_cave, {_x, y}, max) when max == y do
    true
  end

  defp filled?(cave, coordinate, _) do
    Enum.member?(cave, coordinate)
  end

  defp find_impact_point(cave, {source_x, source_y}, max) do
    impact_y =
      source_y..max
      |> Enum.find(fn y ->
        filled?(cave, {source_x, y}, max)
      end)

    {cave, {source_x, impact_y}, max}
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
