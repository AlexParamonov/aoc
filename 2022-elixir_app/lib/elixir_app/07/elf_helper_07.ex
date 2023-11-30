defmodule ElixirApp.ElfHelper07 do
  alias ElixirApp.FileSystem

  def find_all_dirs_and_their_sizes_with_limit(raw_input) do
    FileSystem.load_from_command_log(raw_input)
    |> FileSystem.filter_dir(max_size: 100_000)
    |> Enum.map(&FileSystem.size/1)
    |> Enum.sum()
  end

  def min_max_dir_size(raw_input, required_size: required_size, drive_size: drive_size) do
    fs = FileSystem.load_from_command_log(raw_input)

    total_used_space =
      fs
      |> FileSystem.filter_file()
      |> Enum.map(&FileSystem.size/1)
      |> Enum.sum

    space_needed = required_size - (drive_size - total_used_space)

    fs
    |> FileSystem.filter_dir(min_size: space_needed)
    |> Enum.min_by(&FileSystem.size/1)
    |> FileSystem.size()
  end
end
