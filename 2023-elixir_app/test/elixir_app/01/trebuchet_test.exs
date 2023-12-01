defmodule ElixirApp.TrebuchetTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Trebuchet
  alias ElixirApp.FileFixtures

  describe ".calibration_checksum" do
    setup do
      raw_input = FileFixtures.content("01/demo_trebuchet.txt")
      %{raw_input: raw_input}
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input} do
      assert Trebuchet.calibration_checksum(raw_input) == 142
    end
  end

  describe ".calibrate" do
    test "builds a calibration value" do
      line = "pqr3stu8vwx"
      assert Trebuchet.calibrate(line) == 38
    end

    test "only builds 2 digit numbers" do
      line = "pqr3stu8x4e"
      assert Trebuchet.calibrate(line) == 34
    end
  end

  describe ".calibrate_with_words" do
    test "uses spelled out numbers as digits" do
      line = "two1nine"
      assert Trebuchet.calibrate_with_words(line) == 29
    end

    test "works with repeated numbers" do
      line = "one7one"
      assert Trebuchet.calibrate_with_words(line) == 11
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
      assert Trebuchet.calibration_checksum(raw_input) == 55017
    end

    test "returns a sum of all calibration values using words", %{raw_input: raw_input} do
      assert Trebuchet.calibration_checksum_with_words(raw_input) == 53552
    end
  end
end
