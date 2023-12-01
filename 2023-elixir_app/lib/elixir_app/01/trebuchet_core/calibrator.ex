defmodule ElixirApp.TrebuchetCore.Calibrator do
  @word_regex "one|two|three|four|five|six|seven|eight|nine"

  @spec calibrate(String.t) :: integer
  def calibrate(line) do
    Regex.scan(~r/\d/, line, trim: true)
    |> List.flatten
    |> extract_numbers
    |> String.to_integer
  end

  @spec calibrate_with_words(String.t) :: integer
  def calibrate_with_words(line) do
    [
      find_first_match(line),
      find_last_match(line)
    ]
    |> Enum.map_join(&word_to_number/1)
    |> String.to_integer
  end

  defp find_first_match(line) do
    Regex.run(~r/#{@word_regex}|\d/, line)
    |> List.first
  end

  defp find_last_match(line) do
    Regex.run(~r/#{String.reverse(@word_regex)}|\d/, String.reverse(line))
    |> List.first
    |> String.reverse
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

  defp extract_numbers(list) do
    List.first(list) <> List.last(list)
  end
end
