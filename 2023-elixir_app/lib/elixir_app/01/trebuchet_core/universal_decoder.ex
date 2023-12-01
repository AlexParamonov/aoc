defmodule ElixirApp.TrebuchetCore.UniversalDecoder do
  @word_regex "one|two|three|four|five|six|seven|eight|nine"

  @spec decode(String.t) :: integer
  def decode(line) do
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
end
