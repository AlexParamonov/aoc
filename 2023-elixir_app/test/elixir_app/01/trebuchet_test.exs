defmodule ElixirApp.TrebuchetTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Trebuchet
  alias ElixirApp.TrebuchetBoundary.DecodeHub
  alias ElixirApp.FileFixtures

  setup_all do
    {:ok, _pid} = start_supervised(DecodeHub)
    :ok
  end

  describe ".calibration_checksum" do
    setup do
      raw_input = FileFixtures.content("01/demo_trebuchet.txt")
      %{raw_input: raw_input}
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input} do
      assert Trebuchet.calibration_checksum(raw_input) == 142
    end
  end

  describe ".calibration_checksum_with_words" do
    setup do
      raw_input = FileFixtures.content("01/demo_trebuchet_with_words.txt")
      %{raw_input: raw_input}
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input} do
      assert Trebuchet.calibration_checksum_with_words(raw_input) == 281
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("01/trebuchet.txt")
      %{raw_input: raw_input}
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input} do
      assert Trebuchet.calibration_checksum(raw_input) == 55_017
    end

    test "returns a sum of all calibration values using words", %{raw_input: raw_input} do
      assert Trebuchet.calibration_checksum_with_words(raw_input) == 53_539
    end
  end
end
