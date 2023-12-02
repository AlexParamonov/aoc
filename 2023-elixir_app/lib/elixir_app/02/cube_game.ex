defmodule ElixirApp.CubeGame do
  defmodule Game do
    defstruct [:id, :iterations]
  end

  def validate_games(raw_input, guess) do
    raw_input
    |> parse_list
    |> load_games
    |> filter_games(guess)
    |> Enum.map(& &1.id)
    |> Enum.sum()
  end

  defp load_games(raw_games) do
    raw_games
    |> Enum.map(&load_game/1)
  end

  defp filter_games(games, guess) do
    games
    |> Enum.filter(&valid?(&1, guess))
  end

  defp load_game(raw_game) do
    data = Regex.named_captures(~r/\AGame (?<id>\d+): (?<raw_iterations>.*)\z/, raw_game)

    %Game{
      id: String.to_integer(data["id"]),
      iterations: load_iterations(data["raw_iterations"])
    }
  end

  defp load_iterations(raw_iterations) do
    raw_iterations
    |> parse_list(delimeter: "; ")
    |> Enum.map(&load_iteration/1)
  end

  defp load_iteration(raw_iteration) do
    raw_iteration
    |> parse_list(delimeter: ", ")
    |> Enum.map(fn raw_sample ->
      [number, color] = parse_list(raw_sample, delimeter: " ")

      {String.to_existing_atom(color), String.to_integer(number)}
    end)
  end

  defp valid?(game, guess) do
    game.iterations
    |> Enum.all?(fn iteration_rgb ->
      iteration_rgb
      |> Enum.all?(fn {color, max_seen_count} ->
        max_seen_count <= Map.get(guess, color, 0)
      end)
    end)
  end

  defp parse_list(raw_input, options \\ []) do
    delimeter = Keyword.get(options, :delimeter, "\n")

    raw_input
    |> String.split(delimeter, trim: true)
  end
end
