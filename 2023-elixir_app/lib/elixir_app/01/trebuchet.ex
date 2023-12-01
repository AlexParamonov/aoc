defmodule ElixirApp.Trebuchet do
  def calibration_checksum(raw_input) do
    raw_input
    |> parse_list
    |> Enum.map(&calibrate/1)
    |> Enum.sum()
  end

  @spec calibrate(String.t) :: integer
  def calibrate(line) do
    Regex.scan(~r/\d/, line)
    |> List.flatten
    |> extract_numbers
    |> String.to_integer
  end

  defp parse_list(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
  end

  defp extract_numbers(list) do
    List.first(list) <> List.last(list)
  end
end
