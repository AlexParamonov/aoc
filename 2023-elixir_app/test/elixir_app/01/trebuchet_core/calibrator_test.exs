defmodule ElixirApp.TrebuchetCore.CalibratorTest do
  use ExUnit.Case, async: true

  alias ElixirApp.TrebuchetCore.Calibrator

  describe ".calibrate" do
    test "builds a calibration value" do
      line = "pqr3stu8vwx"
      assert Calibrator.calibrate(line) == 38
    end

    test "only builds 2 digit numbers" do
      line = "pqr3stu8x4e"
      assert Calibrator.calibrate(line) == 34
    end
  end

  describe ".calibrate_with_words" do
    test "uses spelled out numbers as digits" do
      line = "two1nine"
      assert Calibrator.calibrate_with_words(line) == 29
    end

    test "works with repeated numbers" do
      line = "one7one"
      assert Calibrator.calibrate_with_words(line) == 11
    end

    test "works with overlapping text" do
      line = "mjlrpthgvz57skzbs24fourtwoneklr"
      assert Calibrator.calibrate_with_words(line) == 51
    end
  end
end
