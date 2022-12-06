defmodule ElixirApp.SignalDecoderTest do
  use ExUnit.Case
  alias ElixirApp.SignalDecoder

  describe "message start search" do
    [
      {"mjqjpqmgbljsphdztnvjfqwrcgsmlb", %{packet_start: 7, message_start: 19}},
      {"bvwbjplbgvbhsrlpgdmjqwftvncz", %{packet_start: 5, message_start: 23}},
      {"nppdvjthqldpwncqszvftbrmjlhg", %{packet_start: 6, message_start: 23}},
      {"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", %{packet_start: 10, message_start: 29}},
      {"zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", %{packet_start: 11, message_start: 26}},
    ]
    |> Enum.each(fn {input, %{packet_start: packet_start, message_start: message_start}} ->
      test "finds the start of the packet for #{input}" do
        assert SignalDecoder.packet_start(unquote(input)) == unquote(packet_start)
      end

      test "finds the start of the message for #{input}" do
        assert SignalDecoder.message_start(unquote(input)) == unquote(message_start)
      end
    end)

    test "returns nil when no packet start is found" do
      assert SignalDecoder.packet_start("abc") == nil
    end

    test "returns nil when no message start is found" do
      assert SignalDecoder.message_start("abc") == nil
    end
  end
end
