defmodule ElixirApp.CleaningScheduleTest do
  use ExUnit.Case
  alias ElixirApp.CleaningSchedule

  alias ElixirApp.FileFixtures

  setup_all do
    raw_schedule = FileFixtures.content("04/demo_schedule.txt")
    %{raw_schedule: raw_schedule}
  end

  describe ".group_full_overlap_count" do
    test "returns the number of group schedules that overlap fully", %{raw_schedule: raw_schedule} do
      assert CleaningSchedule.group_full_overlap_count(raw_schedule) == 2
    end
  end

  describe ".group_overlap_count" do
    test "returns the number of group schedules that overlap", %{raw_schedule: raw_schedule} do
      assert CleaningSchedule.group_overlap_count(raw_schedule) == 4
    end
  end

  describe "result" do
    setup do
      raw_schedule = FileFixtures.content("04/schedule.txt")
      %{raw_schedule: raw_schedule}
    end

    test "returns the number of group schedules that overlap fully", %{raw_schedule: raw_schedule} do
      assert CleaningSchedule.group_full_overlap_count(raw_schedule) == 518
    end

    test "returns the number of group schedules that overlap", %{raw_schedule: raw_schedule} do
      assert CleaningSchedule.group_overlap_count(raw_schedule) == 909
    end
  end
end
