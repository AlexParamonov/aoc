defmodule ElixirApp.GridVisibility do
  def count_visible_trees(raw_input) do
    raw_input
    |> parse_grid
    |> visible_tree_count
  end

  defp parse_grid(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.with_index()
    |> Enum.map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.map(fn {char, x} ->
        {char, x, y}
      end)
    end)
  end

  defp visible_tree_count(grid) do
    [
      horizontally_visible_trees(grid),
      vertically_visible_trees(grid)
    ]
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
    |> Kernel.+(edge_visible_tree_count(grid))
  end

  defp horizontally_visible_trees(grid) do
    grid
    |> Enum.slice(1..-2)
    |> Enum.reduce([], fn line, visible_trees ->
      inner_trees = Enum.slice(line, 1..-2)
      visible_trees ++ Enum.filter(inner_trees, &visible_in_line?(line, &1))
    end)
  end

  defp vertically_visible_trees(grid) do
    grid
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.slice(1..-2)
    |> Enum.reduce([], fn line, visible_trees ->
      inner_trees = Enum.slice(line, 1..-2)
      visible_trees ++ Enum.filter(inner_trees, &visible_in_col?(line, &1))
    end)
  end

  # Playing with Kernel.fun()
  defp edge_visible_tree_count(grid) do
    (Enum.count(Enum.at(grid, 0)) * 2)
    |> Kernel.+(Enum.count(grid) * 2)
    |> Kernel.-(4)
  end

  defp visible_in_line?(line, {value, x, _y}) do
    {left, right} = Enum.split(line, x)
    right = Enum.slice(right, 1..-1)

    [left, right]
    |> Enum.any?(fn side ->
      side
      |> Enum.map(&elem(&1, 0))
      |> Enum.max() < value
    end)
  end

  defp visible_in_col?(line, {value, _x, y}) do
    {left, right} = Enum.split(line, y)
    right = Enum.slice(right, 1..-1)

    [left, right]
    |> Enum.any?(fn side ->
      side
      |> Enum.map(&elem(&1, 0))
      |> Enum.max() < value
    end)
  end
end
