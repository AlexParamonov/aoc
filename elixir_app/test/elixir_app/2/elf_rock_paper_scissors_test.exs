defmodule ElixirApp.ElfRockPaperScissorsTest do
  use ExUnit.Case
  alias ElixirApp.ElfRockPaperScissors

  alias ElixirApp.FileFixtures

  setup_all do
    game_log = FileFixtures.content("2/demo_game.txt")
    %{game_log: game_log}
  end

  describe ".result with player_action assumption" do
    test "returns returns the game result", %{game_log: game_log} do
      assert ElfRockPaperScissors.play(game_log, :player_action) == 15
    end

    test "returns input game result" do
      game_log = FileFixtures.content("2/game_input.txt")
      assert ElfRockPaperScissors.play(game_log, :player_action) == 14_375
    end
  end

  describe ".result" do
    test "returns returns the game result", %{game_log: game_log} do
      assert ElfRockPaperScissors.play(game_log, :game_result) == 12
    end

    test "returns input game result" do
      game_log = FileFixtures.content("2/game_input.txt")
      assert ElfRockPaperScissors.play(game_log, :game_result) == 10_274
    end
  end
end
