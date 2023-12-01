defmodule ElixirApp.TrebuchetCore.UniversalDecoderTest do
  use ExUnit.Case, async: true

  alias ElixirApp.TrebuchetCore.UniversalDecoder

  describe ".decode" do
    test "only builds 2 digit numbers" do
      line = "pqr3stu8x4e"
      assert UniversalDecoder.decode(line) == 34
    end

    test "uses spelled out numbers as digits" do
      line = "two1nine"
      assert UniversalDecoder.decode(line) == 29
    end

    test "works with repeated numbers" do
      line = "one7one"
      assert UniversalDecoder.decode(line) == 11
    end

    test "works with overlapping text" do
      line = "mjlrpthgvz57skzbs24fourtwoneklr"
      assert UniversalDecoder.decode(line) == 51
    end
  end
end
