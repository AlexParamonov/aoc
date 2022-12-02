defmodule ElixirApp.ElfRockPaperScissors do
  def play(game_input_log, assumption) do
    game_input_log
    |> parse_game_input_log()
    |> play_games(assumption)
    |> total_score()
  end

  defp parse_game_input_log(game_input_log) do
    game_input_log
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" ")
      |> List.to_tuple()
    end)
  end

  defp play_games(game_log, assumption) do
    game_log
    |> Enum.map(fn game_log_entry ->
      game_log_entry
      |> decode(assumption: assumption)
      |> play_game()
    end)
  end

  defp total_score(game_outcomes) do
    game_outcomes
    |> Enum.map(&game_outcome_to_score/1)
    |> Enum.sum()
  end

  defp play_game({game_result, opponent_action} = game_entry) when game_result in [:win, :loose, :draw] do
    shape = {pick_shape(game_entry), opponent_action}
    {game_rules(shape), shape}
  end

  defp pick_shape({game_result, opponent_action}) do
    case game_result do
      :win -> winning_shape(opponent_action)
      :loose -> loosing_shape(opponent_action)
      :draw -> draw_shape(opponent_action)
    end
  end

  def winning_shape(opponent_action) do
    case opponent_action do
      :rock -> :paper
      :paper -> :scissors
      :scissors -> :rock
    end
  end

  def loosing_shape(opponent_action) do
    case opponent_action do
      :rock -> :scissors
      :paper -> :rock
      :scissors -> :paper
    end
  end

  def draw_shape(opponent_action) do
    opponent_action
  end

  defp play_game(game_entry) do
    {game_rules(game_entry), game_entry}
  end

  defp game_rules(shape) do
    case shape do
      {:rock, :scissors} -> :win
      {:scissors, :paper} -> :win
      {:paper, :rock} -> :win
      {:scissors, :rock} -> :loose
      {:paper, :scissors} -> :loose
      {:rock, :paper} -> :loose
      _ -> :draw
    end
  end

  defp game_outcome_to_score({:win, shape}), do: 6 + shape_score(shape)
  defp game_outcome_to_score({:draw, shape}), do: 3 + shape_score(shape)
  defp game_outcome_to_score({:loose, shape}), do: 0 + shape_score(shape)

  defp shape_score({shape, _}) do
    case shape do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  defp decode({opponent_action, player_action}, assumption: :player_action) do
    {decode_player_action(player_action), decode_opponent_action(opponent_action)}
  end

  defp decode({opponent_action, game_result}, assumption: :game_result) do
    {decode_expected_result(game_result), decode_opponent_action(opponent_action)}
  end

  defp decode_opponent_action(action) do
    case action do
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
    end
  end

  defp decode_player_action(action) do
    case action do
      "X" -> :rock
      "Y" -> :paper
      "Z" -> :scissors
    end
  end

  defp decode_expected_result(result) do
    case result do
      "X" -> :loose
      "Y" -> :draw
      "Z" -> :win
    end
  end
end
