defmodule ElixirApp.ElfHelper07Test do
  use ExUnit.Case
  alias ElixirApp.ElfHelper07

  alias ElixirApp.FileFixtures

  setup_all do
    raw_input = FileFixtures.content("07/demo_file_system.txt")
    %{raw_input: raw_input}
  end

  describe ".find_all_dirs_and_their_sizes_with_limit" do
    test "counts the size of filtered dirs", %{raw_input: raw_input} do
      assert ElfHelper07.find_all_dirs_and_their_sizes_with_limit(raw_input) == 95_437
    end
  end

  describe ".min_max_dir" do
    test "returns the smallest of the biggest dirs", %{raw_input: raw_input} do
      assert ElfHelper07.min_max_dir_size(raw_input, required_size: 30_000_000, drive_size: 70_000_000) == 24_933_642
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("07/file_system.txt")
      %{raw_input: raw_input}
    end

    test "counts the size of filtered dirs", %{raw_input: raw_input} do
      assert ElfHelper07.find_all_dirs_and_their_sizes_with_limit(raw_input) == 1_307_902
    end

    test "returns the smallest of the biggest dirs", %{raw_input: raw_input} do
      assert ElfHelper07.min_max_dir_size(raw_input, required_size: 30_000_000, drive_size: 70_000_000) == 7_068_748
    end
  end
end
