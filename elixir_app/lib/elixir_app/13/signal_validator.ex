defmodule ElixirApp.SignalValidator do
  def sum_of_valid_signal_ids(raw_input) do
    raw_input
    |> parse_input
    |> filter_valid_signals
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def load(raw_input) do
    raw_input
    |> String.trim()
    |> String.replace("\n\n", "\n")
    |> String.split("\n")
    |> Enum.map(&load_signal/1)
  end

  def sort(raw_input) do
    raw_input
    |> load
    |> inject_signals([[[2]], [[6]]])
    |> Enum.sort(&valid_signal?/2)
  end

  def decoder_key(raw_input) do
    list = sort(raw_input)

    find_decoder_key_index(list, [[2]]) * find_decoder_key_index(list, [[6]])
  end

  defp find_decoder_key_index(list, signal) do
    list
    |> Enum.find_index(&(&1 == signal))
    |> Kernel.+(1)
  end

  defp inject_signals(signals, extra_signals) do
    signals ++ extra_signals
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
    |> Enum.map(&load_signal/1)
    |> List.to_tuple()
  end

  defp load_signal(raw_signal) do
    raw_signal
    |> Code.eval_string()
    |> elem(0)
  end
end
