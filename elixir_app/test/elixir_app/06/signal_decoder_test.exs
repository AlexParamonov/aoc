defmodule ElixirApp.SignalDecoderTest do
  use ExUnit.Case
  alias ElixirApp.SignalDecoder

  describe ".message_start" do
    [
      {"mjqjpqmgbljsphdztnvjfqwrcgsmlb", 7},
      {"bvwbjplbgvbhsrlpgdmjqwftvncz", 5},
      {"nppdvjthqldpwncqszvftbrmjlhg", 6},
      {"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10},
      {"zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11}
    ]
    |> Enum.each(fn {input, expected} ->
      test "finds the start of the message for #{input}" do
        assert SignalDecoder.message_start(unquote(input)) == unquote(expected)
      end
    end)
  end
end
