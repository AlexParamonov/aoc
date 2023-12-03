defmodule ElixirApp.Engine do
  # TODO 0..9
  @numbers ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

  def sum_parts(raw_input) do
    matrix =
      raw_input
      |> load_matrix

    matrix
    |> build_adjacent_positions
    |> load_numbers(matrix)
    |> Enum.sum()
  end

  def load_matrix(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def build_adjacent_positions(matrix) do
    matrix
    |> find_symbol_positions
    |> expand_positions
    |> filter_empty_positions(matrix)
    |> adjust_for_starting_position(matrix)
    |> Enum.uniq()
  end

  defp find_symbol_positions(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.reduce([], fn {row, row_index}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {value, _index}, row_acc when value in ["." | @numbers] ->
          row_acc

        {_value, index}, row_acc ->
          [{row_index, index} | row_acc]
      end)
      |> Kernel.++(acc)
    end)
  end

  defp expand_positions(positions) do
    positions
    |> Enum.map(fn {row, index} ->
      [
        {row, index - 1},
        {row, index + 1},
        {row + 1, index},
        {row + 1, index + 1},
        {row + 1, index - 1},
        {row - 1, index + 1},
        {row - 1, index - 1},
        {row - 1, index}
      ]
      |> Enum.filter(fn
        {-1, _index} -> false
        {_row, -1} -> false
        _ -> true
      end)
    end)
    |> List.flatten()
  end

  defp filter_empty_positions(positions, matrix) do
    positions
    |> Enum.filter(fn {row_index, index} ->
      "." !=
        matrix
        |> Enum.at(row_index)
        |> Enum.at(index)
    end)
  end

  defp adjust_for_starting_position(positions, matrix) do
    positions
    |> Enum.map(fn {row_index, index} ->
      matrix
      |> Enum.at(row_index)
      |> Enum.at(index)
      |> shift_position_left(row_index, index, matrix)
    end)
  end

  defp shift_position_left(_value, row_index, -1, _matrix), do: {row_index, 0}

  defp shift_position_left(value, row_index, index, matrix) when value in @numbers do
    new_index = index - 1

    new_value =
      matrix
      |> Enum.at(row_index)
      |> Enum.at(new_index)

    shift_position_left(new_value, row_index, new_index, matrix)
  end

  defp shift_position_left(_value, row_index, index, _matrix), do: {row_index, index + 1}


  def load_numbers(adjacent_positions, matrix) do
    adjacent_positions
    |> Enum.map(fn {row_index, index} ->
      matrix
      |> Enum.at(row_index)
      |> number_at_index(index)
    end)
  end

  defp number_at_index(line, index) do
    value = Enum.at(line, index)
    number_at_index(value, line, index, "")
  end

  defp number_at_index(value, line, index, acc) when value in @numbers do
    new_index = index + 1
    new_value = Enum.at(line, new_index)

    number_at_index(new_value, line, new_index, acc <> value)
  end

  defp number_at_index(_value, _line, _index, acc) do
    acc
    |> String.to_integer()
  end
end
