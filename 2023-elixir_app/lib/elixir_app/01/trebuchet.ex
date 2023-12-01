defmodule ElixirApp.Trebuchet do
  alias ElixirApp.TrebuchetCore.Calibrator

  def calibration_checksum_with_words(raw_input) do
    raw_input
    |> parse_list
    |> Enum.map(&Calibrator.calibrate_with_words/1)
    |> Enum.sum()
  end

  def calibration_checksum(raw_input) do
    raw_input
    |> parse_list
    |> Enum.map(&Calibrator.calibrate/1)
    |> Enum.sum()
  end

  defp parse_list(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
  end
end
