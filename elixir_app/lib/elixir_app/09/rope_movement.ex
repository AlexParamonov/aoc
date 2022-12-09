defmodule ElixirApp.RopeMovement do
  def count_uniq_tail_positions(raw_head_movements, knots: knot_count) do
    head = {10_000, 10_000}

    head_path =
      raw_head_movements
      |> parse_head_movements(head)

    1..knot_count
    |> Enum.reduce(head_path, fn _, path ->
      tail_path(path, head)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp parse_head_movements(raw_head_movements, head) do
    raw_head_movements
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce([head], fn raw_head_movement, head_path_list ->
      current_head = List.last(head_path_list)

      head_path_in_one_direction =
        raw_head_movement
        |> String.split()
        |> head_path(current_head)

      head_path_list ++ head_path_in_one_direction
    end)
    |> List.flatten()
  end

  defp head_path(["R", count], {row, col}), do: for(i <- 1..String.to_integer(count), do: {row, col + i})
  defp head_path(["L", count], {row, col}), do: for(i <- 1..String.to_integer(count), do: {row, col - i})
  defp head_path(["U", count], {row, col}), do: for(i <- 1..String.to_integer(count), do: {row - i, col})
  defp head_path(["D", count], {row, col}), do: for(i <- 1..String.to_integer(count), do: {row + i, col})

  defp tail_path(head_path, tail) do
    head_path
    |> Enum.reduce([tail], fn head, tail_path_list ->
      current_tail = List.first(tail_path_list)

      tail = move_tail(head: head, tail: current_tail)
      [tail | tail_path_list]
    end)
    |> Enum.reverse()
  end

  def move_tail(head: head, tail: tail) do
    if touching?(head, tail) do
      tail
    else
      move_to_head(head, tail)
    end
  end

  def touching?({head_row, head_col}, {tail_row, tail_col}) do
    Enum.member?((head_row - 1)..(head_row + 1), tail_row) and
      Enum.member?((head_col - 1)..(head_col + 1), tail_col)
  end

  defp move_to_head({head_row, head_col}, {tail_row, tail_col}) do
    row_direction = movement_direction(head_row, tail_row)
    col_direction = movement_direction(head_col, tail_col)

    cond do
      head_row == tail_row -> {tail_row, tail_col + col_direction}
      head_col == tail_col -> {tail_row + row_direction, tail_col}
      true -> {tail_row + row_direction, tail_col + col_direction}
    end
  end

  defp movement_direction(head_pos, tail_pos) when head_pos > tail_pos, do: 1
  defp movement_direction(head_pos, tail_pos) when head_pos < tail_pos, do: -1
  defp movement_direction(head_pos, tail_pos) when head_pos == tail_pos, do: 0
end
