defmodule ElixirApp.Signal do
  def draw(raw_input) do
    cycles(raw_input)
    |> Enum.slice(1..-1)
    |> Enum.chunk_every(40)
    |> Enum.map(&draw_line/1)
    |> Enum.join("\n")
  end

  def cycles(raw_input) do
    raw_input
    |> parse_input
    |> to_cycles
  end

  def report_signal(raw_input, cycle) do
    cycles(raw_input)
    |> Enum.at(cycle)
    |> add_signal
  end

  def sum_signal_on_cycles(raw_input, cycles: cycles) do
    cycles(raw_input)
    |> Map.new()
    |> Map.take(cycles)
    |> Enum.map(&calculate_signal/1)
    |> Enum.sum()
  end

  defp parse_input(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      parse_line(String.split(line, " "))
    end)
  end

  defp parse_line(["noop"]), do: {:noop, 0}
  defp parse_line(["addx", value]), do: {:addx, String.to_integer(value)}

  defp to_cycles(commands) do
    commands
    |> Enum.reduce([{0, 1, :noop}], fn {command, x_increment}, acc ->
      {last_cycle, last_x, pending_change} = List.first(acc)

      new_x = last_x + pending_change_x(pending_change)

      case command do
        :noop -> [{last_cycle + 1, new_x, :noop} | acc]
        :addx -> [{last_cycle + 2, new_x, x_increment} | [{last_cycle + 1, new_x, :noop} | acc]]
      end
    end)
    |> Enum.reverse()
    |> Enum.map(fn {cycle, x, _pending_change} ->
      {cycle, x}
    end)
  end

  defp pending_change_x(:noop), do: 0
  defp pending_change_x(val), do: val

  defp add_signal({cycle, x}) do
    {cycle, x, calculate_signal({cycle, x})}
  end

  defp calculate_signal({cycle, x}) do
    x * cycle
  end

  defp draw_line(cycles) do
    cycles
    |> Enum.map(&draw_in_cycle/1)
    |> Enum.join()
  end

  defp draw_in_cycle({cycle, x}) do
    position = position_from_cycle(cycle)

    if position in (x - 1)..(x + 1) do
      "#"
    else
      "."
    end
  end

  defp position_from_cycle(cycle) do
    cycle - 1
    |> rem(40)
  end
end
