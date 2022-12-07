defmodule ElixirApp.FileSystemTest do
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
end
