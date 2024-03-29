defmodule ElixirApp.Trebuchet do
  def calibration_checksum_with_words(raw_input, decoder) do
    raw_input
    |> parse_list
    |> Enum.map(&decoder.decode_words_and_numbers/1)
    |> calibrate
  end

  def calibration_checksum(raw_input, decoder) do
    raw_input
    |> parse_list
    |> Enum.map(&decoder.decode_numbers/1)
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
