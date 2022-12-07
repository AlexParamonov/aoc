defmodule ElixirApp.ElfHelper07 do
  alias ElixirApp.FileSystem

  def find_all_dirs_and_their_sizes_with_limit(raw_input) do
    FileSystem.load_from_command_log(raw_input)
    |> FileSystem.filter_dir(max_size: 100_000)
    |> Enum.map(&FileSystem.size/1)
    |> Enum.sum()
  end
end
