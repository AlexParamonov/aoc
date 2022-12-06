defmodule ElixirApp.SignalDecoder do
  def message_start(input) do
    input
    |> String.to_charlist()
    |> find_marker_index()
  end

  @spec find_marker_index(list(char)) :: integer
  defp find_marker_index(list, marker_length \\ 4) do
    Enum.reduce_while(list, 0, fn _char, index ->
      possible_marker = Enum.slice(list, index..(index + marker_length - 1))
      cond do
        possible_marker == Enum.uniq(possible_marker) -> {:halt, index + marker_length}
        true -> {:cont, index + 1}
      end
    end)
  end
end
