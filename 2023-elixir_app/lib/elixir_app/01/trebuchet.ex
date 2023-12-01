defmodule ElixirApp.Trebuchet do
  alias ElixirApp.TrebuchetCore.{NumericDecoder, UniversalDecoder}

  def calibration_checksum_with_words(raw_input) do
    raw_input
    |> parse_list
    |> Enum.map(&UniversalDecoder.decode/1)
    |> calibrate
  end

  def calibration_checksum(raw_input) do
    raw_input
    |> parse_list
    |> Enum.map(&NumericDecoder.decode/1)
    |> calibrate
  end

  defp calibrate(list) do
    Enum.sum(list)
  end

  defp parse_list(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
  end
end
