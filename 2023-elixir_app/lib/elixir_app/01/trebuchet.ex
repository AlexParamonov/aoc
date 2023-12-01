defmodule ElixirApp.Trebuchet do
  @word_regex "one|two|three|four|five|six|seven|eight|nine"

  def calibration_checksum_with_words(raw_input) do
    raw_input
    |> parse_list
    |> Enum.map(&calibrate_with_words/1)
    # |> Enum.map(& if &1 > 99, do: dbg(&1), else: &1)
    |> Enum.sum()
  end

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

  def calibrate_with_words(line) do
    Regex.scan(~r/#{@word_regex}|\d/, line)
    |> List.flatten
    |> Enum.map(&word_to_number/1)
    |> extract_numbers
    |> String.to_integer
  end

  defp word_to_number(word) do
    case word do
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
      _ -> word
    end
  end

  defp parse_list(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
  end

  defp extract_numbers(list) do
    List.first(list) <> List.last(list)
  end
end
