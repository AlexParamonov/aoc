defmodule ElixirApp.CubeGameTest do
  use ExUnit.Case, async: true

  alias ElixirApp.CubeGame
  alias ElixirApp.FileFixtures

  setup do
    raw_input = FileFixtures.content("02/demo_game.txt")

    %{raw_input: raw_input}
  end

  describe ".validate_games" do
    test "returns a sum of possible game ids for a given guess", %{raw_input: raw_input} do
      guess = %{red: 12, green: 13, blue: 14}

      assert 8 == CubeGame.validate_games(raw_input, guess)
    end
  end

  describe ".minmax_power_sum" do
    test "finds min possible set of cubes, multiplies them and sums results of all games", %{raw_input: raw_input}  do
      assert 2_286 == CubeGame.minmax_power_sum(raw_input)
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("02/game.txt")

      %{raw_input: raw_input}
    end

    test "returns a sum of possible game ids for a given guess", %{raw_input: raw_input} do
      guess = %{red: 12, green: 13, blue: 14}

      assert 1_853 == CubeGame.validate_games(raw_input, guess)
    end

    test "finds min possible set of cubes, multiplies them and sums results of all games", %{raw_input: raw_input}  do
      assert 72_706 == CubeGame.minmax_power_sum(raw_input)
    end
  end
end
