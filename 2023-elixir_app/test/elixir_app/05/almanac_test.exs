defmodule ElixirApp.AlmanacTest do
  use ExUnit.Case, async: true
  use FlowAssertions

  alias ElixirApp.Almanac
  alias ElixirApp.FileFixtures

  setup do
    raw_input = FileFixtures.content("05/demo_almanac.txt")

    %{raw_input: raw_input}
  end

  describe "load" do
    # test "returns a tuple of the seed list and the maps", %{raw_input: raw_input} do
    #   {seeds, maps} =
    #     raw_input
    #     |> Almanac.load()

    #   assert [79, 14, 55, 13] == seeds

    #   assert_fields(
    #     maps,
    #     %{
    #       "seed-to-soil" => [[50, 98, 2], [52, 50, 48]],
    #       "soil-to-fertilizer" => [[0, 15, 37], [37, 52, 2], [39, 0, 15]],
    #       "fertilizer-to-water" => [[49, 53, 8], [0, 11, 42], [42, 0, 7], [57, 7, 4]],
    #       "water-to-light" => [[88, 18, 7], [18, 25, 70]],
    #       "light-to-temperature" => [[45, 77, 23], [81, 45, 19], [68, 64, 13]],
    #       "temperature-to-humidity" => [[0, 69, 1], [1, 0, 69]],
    #       "humidity-to-location" => [[60, 56, 37], [56, 93, 4]]
    #     }
    #   )
    # end
  end

  describe ".load_seed_range" do
    # test "returns a tuple of the seed list and the maps", %{raw_input: raw_input} do
    #   {seeds, maps} =
    #     raw_input
    #     |> Almanac.load_seed_range()

    #   assert 27 == length(seeds)

    #   assert_fields(
    #     maps,
    #     %{
    #       "seed-to-soil" => [[50, 98, 2], [52, 50, 48]],
    #       "soil-to-fertilizer" => [[0, 15, 37], [37, 52, 2], [39, 0, 15]],
    #       "fertilizer-to-water" => [[49, 53, 8], [0, 11, 42], [42, 0, 7], [57, 7, 4]],
    #       "water-to-light" => [[88, 18, 7], [18, 25, 70]],
    #       "light-to-temperature" => [[45, 77, 23], [81, 45, 19], [68, 64, 13]],
    #       "temperature-to-humidity" => [[0, 69, 1], [1, 0, 69]],
    #       "humidity-to-location" => [[60, 56, 37], [56, 93, 4]]
    #     }
    #   )
    # end
  end

  describe ".apply_transformation" do
    test "returns corresponding number after the transformation" do
      transformation = [[60, 56, 37], [56, 93, 4]]
      number = 78
      result = 82

      assert result == Almanac.apply_transformation(number, transformation)
    end
  end

  describe ".min_location" do
    test "returns the lowest location number that corresponds to any of the initial seed numbers", %{raw_input: raw_input} do
      assert 35 ==
               raw_input
               |> Almanac.load()
               |> Almanac.min_location()
    end
  end

  describe ".min_location with seed range" do
    test "returns the lowest location number that corresponds to any of the initial seed ranges", %{raw_input: raw_input} do
      assert 46 ==
               raw_input
               |> Almanac.load_seed_range()
               |> Almanac.min_location()
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("05/almanac.txt")
      %{raw_input: raw_input}
    end

    test "returns the lowest location number that corresponds to any of the initial seed numbers", %{raw_input: raw_input} do
      assert 157_211_394 ==
               raw_input
               |> Almanac.load()
               |> Almanac.min_location()
    end

    test "returns the lowest location number that corresponds to any of the initial seed ranges", %{raw_input: raw_input} do
      assert 50_855_035 ==
               raw_input
               |> Almanac.load_seed_range()
               |> Almanac.min_location()
    end
  end
end
