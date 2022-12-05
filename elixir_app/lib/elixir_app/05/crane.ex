defmodule ElixirApp.Crane do
  def sort(pile, opts) do
    defaults = [using: :model_9000]
    opts = Keyword.merge(defaults, opts)
    %{with: instructions, using: crane_model} = Enum.into(opts, %{})

    run_sort(pile, instructions, crane_model)
  end

  defp run_sort(pile, instructions, crane_model) when is_list(instructions) and is_map(pile) do
    Enum.reduce(instructions, pile, fn instruction, pile ->
      execute_instruction(pile, instruction, crane_model)
    end)
  end

  defp run_sort(_pile, _instruction, _crane_model) do
    raise "invalid instructions or pile"
  end

  defp execute_instruction(pile, %{from: from, to: to, count: item_count}, crane_model) do
    source_column = pile[from]
    destination_column = pile[to]

    chunk_to_move = pick_items(source_column, item_count, crane_model)

    pile
    |> Map.put(from, Enum.drop(source_column, -item_count))
    |> Map.put(to, destination_column ++ chunk_to_move)
  end

  defp pick_items(source_column, item_count, :model_9001) do
    source_column
    |> Enum.take(-item_count)
  end

  defp pick_items(source_column, item_count, _crane_model) do
    source_column
    |> Enum.take(-item_count)
    |> Enum.reverse
  end
end
