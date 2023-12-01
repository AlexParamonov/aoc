defmodule ElixirApp.TrebuchetTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Trebuchet
  alias ElixirApp.TrebuchetBoundary.DecodeHub
  alias ElixirApp.FileFixtures

  setup do
    {:ok, _pid} = start_supervised(DecodeHub)
    %{decoder: DecodeHub}
  end

  describe ".calibration_checksum" do
    setup context do
      raw_input = FileFixtures.content("01/demo_trebuchet.txt")

      context
      |> Map.put(:raw_input, raw_input)
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input, decoder: decoder} do
      assert Trebuchet.calibration_checksum(raw_input, decoder) == 142
    end
  end

  describe ".calibration_checksum_with_words" do
    setup do
      raw_input = FileFixtures.content("01/demo_trebuchet_with_words.txt")
      %{raw_input: raw_input}
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input, decoder: decoder} do
      assert Trebuchet.calibration_checksum_with_words(raw_input, decoder) == 281
    end
  end

  describe "result" do
    setup context do
      raw_input = FileFixtures.content("01/trebuchet.txt")

      context
      |> Map.put(:raw_input, raw_input)
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input, decoder: decoder} do
      assert Trebuchet.calibration_checksum(raw_input, decoder) == 55_017
    end

    test "returns a sum of all calibration values using words", %{raw_input: raw_input, decoder: decoder} do
      assert Trebuchet.calibration_checksum_with_words(raw_input, decoder) == 53_539
    end
  end
end
