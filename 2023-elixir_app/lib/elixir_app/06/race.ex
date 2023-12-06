defmodule ElixirApp.Race do
  def ways_to_win_power(raw_input) do
    raw_input
    |> parse_list(delimeter: "\n")
    |> load_table
    |> Enum.map(&ways_to_win/1)
    |> Enum.reduce(&Kernel.*/2)
  end

  def ways_to_win_long_race_power(raw_input) do
    raw_input
    |> parse_list(delimeter: "\n")
    |> load_long_table
    |> ways_to_win()
  end

  def ways_to_win({target_time, target_distance}) do
    calculate_edge({target_time, target_distance})
    |> count_ways_to_win
  end

  defp count_ways_to_win({left_edge, right_edge}) when floor(right_edge) == right_edge do
    count_ways_to_win({left_edge, right_edge - 0.9})
  end

  defp count_ways_to_win({left_edge, right_edge}) when ceil(left_edge) == left_edge do
    count_ways_to_win({left_edge + 0.9, right_edge})
  end


  defp count_ways_to_win({left_edge, right_edge}) do
    floor(right_edge) - ceil(left_edge) + 1
  end

  defp calculate_distance(time, target_time) do
    time * (target_time - time)
  end

  defp calculate_edge({time, distance}) do
    {
      (time - Math.sqrt(time**2 - 4 * distance)) / 2,
      (time + Math.sqrt(time**2 - 4 * distance)) / 2
    }
  end

  defp load_table(raw_input) do
    raw_input
    |> Enum.map(&load_map/1)
    |> Enum.zip
  end

  defp load_long_table(raw_input) do
    raw_input
    |> Enum.map(&load_long_map/1)
    |> List.to_tuple
  end

  defp load_long_map(raw_line) do
    raw_line
    |> parse_list(delimeter: " ")
    |> Enum.slice(1..-1)
    |> Enum.join("")
    |> String.to_integer
  end

  defp load_map(raw_line) do
    raw_line
    |> parse_list(delimeter: " ")
    |> Enum.slice(1..-1)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_list(raw_input, delimeter: delimeter) do
    raw_input
    |> String.split(delimeter, trim: true)
  end
end
