defmodule ElixirApp.CleaningSchedule do
  def group_full_overlap_count(raw_schedule) do
    raw_schedule
    |> parse_schedule
    |> find_schedules_with_full_overlap
    |> Enum.count()
  end

  def group_overlap_count(raw_schedule) do
    raw_schedule
    |> parse_schedule
    |> find_schedules_with_overlap
    |> Enum.count()
  end

  defp find_schedules_with_overlap(schedule) do
    schedule
    |> Enum.filter(&overlap?/1)
  end

  defp overlap?(group_schedule) do
    [set1, set2] = Enum.map(group_schedule, &MapSet.new/1)

    MapSet.intersection(set1, set2) != MapSet.new([])
  end

  defp find_schedules_with_full_overlap(schedule) do
    schedule
    |> Enum.filter(&full_overlap?/1)
  end

  defp full_overlap?(group_schedule) do
    [set1, set2] =
      group_schedule
      |> Enum.sort_by(&Enum.count/1)
      |> Enum.map(&MapSet.new/1)

    MapSet.subset?(set1, set2)
  end

  defp parse_schedule(raw_schedule) do
    raw_schedule
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_group_schedule/1)
  end

  defp parse_group_schedule(raw_group_schedule) do
    raw_group_schedule
    |> String.split(",")
    |> Enum.map(&schedule_to_range/1)
  end

  defp schedule_to_range(input) do
    [first, last] =
      input
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    %Range{first: first, last: last, step: 1}
  end
end
