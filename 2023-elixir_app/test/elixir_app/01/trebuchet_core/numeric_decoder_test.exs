defmodule ElixirApp.TrebuchetCore.NumericDecoderTest do
  use ExUnit.Case, async: true

  alias ElixirApp.TrebuchetCore.NumericDecoder

  describe ".decode" do
    test "builds a calibration value" do
      line = "pqr3stu8vwx"
      assert NumericDecoder.decode(line) == 38
    end

    test "only builds 2 digit numbers" do
      line = "pqr3stu8x4e"
      assert NumericDecoder.decode(line) == 34
    end
  end
end
