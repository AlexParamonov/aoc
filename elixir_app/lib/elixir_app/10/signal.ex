defmodule ElixirApp.Signal do
  def milestones(raw_input) do
    raw_input
    |> parse_input
    |> to_milestones
  end

  def report_signal(raw_input, milestone) do
    milestones(raw_input)
    |> Enum.at(milestone)
    |> add_signal
  end

  def sum_signal_on_milestones(raw_input, milestones: milestones) do
    milestones(raw_input)
    |> Map.new
    |> Map.take(milestones)
    |> Enum.map(&calculate_signal/1)
    |> Enum.sum
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

  defp to_milestones(commands) do
    commands
    |> Enum.reduce([{0, 1, :noop}], fn {command, x_increment}, acc ->
      {last_milestone, last_x, pending_change} = List.first(acc)

      new_x = last_x + pending_change_x(pending_change)

      case command do
        :noop -> [{last_milestone + 1, new_x, :noop} | acc]
        :addx -> [{last_milestone + 2, new_x, x_increment} | [{last_milestone + 1, new_x, :noop} | acc]]
      end
    end)
    |> Enum.reverse()
    |> Enum.map(fn {milestone, x, _pending_change} ->
      {milestone, x}
    end)
  end

  defp pending_change_x(:noop), do: 0
  defp pending_change_x(val), do: val

  defp add_signal({milestone, x}) do
    {milestone, x, calculate_signal({milestone, x})}
  end

  defp calculate_signal({milestone, x}) do
    x * milestone
  end
end
