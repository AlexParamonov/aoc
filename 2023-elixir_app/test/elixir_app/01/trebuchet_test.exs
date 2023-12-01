defmodule ElixirApp.TrebuchetTest do
  use ExUnit.Case, async: true

  alias ElixirApp.Trebuchet
  alias ElixirApp.FileFixtures

  setup_all do
    raw_input = FileFixtures.content("01/demo_trebuchet.txt")
    %{raw_input: raw_input}
  end

  describe ".calibration_checksum" do
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

  describe "result" do
    setup do
      raw_input = FileFixtures.content("01/trebuchet.txt")
      %{raw_input: raw_input}
    end

    test "returns a sum of all calibration values", %{raw_input: raw_input} do
      assert Trebuchet.calibration_checksum(raw_input) == 142
    end
  end
end
