defmodule ElixirApp.SignalValidator do
  def sum_of_valid_signal_ids(raw_input) do
    raw_input
    |> parse_input
    |> filter_valid_signals
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  defp filter_valid_signals(signals) do
    signals
    |> Enum.filter(fn {_id, {signal1, signal2}} -> valid_signal?(signal1, signal2) end)
  end

  defp valid_signal?(val1, val2) when val1 === val2, do: :continue
  defp valid_signal?(val1, _val2) when val1 == [], do: true
  defp valid_signal?(_val1, val2) when val2 == [], do: false
  defp valid_signal?(val1, val2) when is_integer(val1) and is_integer(val2), do: val1 < val2

  defp valid_signal?([val1 | rest1], [val2 | rest2]) do
    valid_signal?(val1, val2)
    |> case do
      :continue -> valid_signal?(rest1, rest2)
      result -> result
    end
  end

  defp valid_signal?(val1, val2) when is_list(val1), do: valid_signal?(val1, [val2])
  defp valid_signal?(val1, val2) when is_list(val2), do: valid_signal?([val1], val2)

  defp parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.with_index()
    |> Enum.map(fn {raw_signal, index} ->
      {index + 1, parse_signals(raw_signal)}
    end)
  end

  defp parse_signals(raw_signal) do
    raw_signal
    |> String.split("\n")
    |> Enum.map(fn raw_signal ->
      raw_signal
      |> Code.eval_string()
      |> elem(0)
    end)
    |> List.to_tuple()
  end
end
