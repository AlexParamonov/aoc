defmodule ElixirApp.TrebuchetCore.NumericDecoder do
  @spec decode(String.t) :: integer
  def decode(line) do
    Regex.scan(~r/\d/, line, trim: true)
    |> List.flatten
    |> extract_numbers
    |> String.to_integer
  end

  defp extract_numbers(list) do
    List.first(list) <> List.last(list)
  end
end
