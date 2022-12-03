defmodule ElixirApp.ElfStash do
  @spec top_carrier_calories(binary()) :: integer
  def top_carrier_calories(stash) do
    stash
    |> parse_stash
    |> Enum.max()
  end

  @spec top_group_calories(binary(), group_size: integer()) :: integer
  def top_group_calories(stash, group_size: group_size) do
    stash
    |> parse_stash
    |> Enum.sort(:desc)
    |> Enum.take(group_size)
    |> Enum.sum()
  end

  defp parse_stash(stash) do
    stash
    |> String.split("\n\n")
    |> Enum.map(&parse_elf_stash/1)
  end

  defp parse_elf_stash(elf_stash) do
    elf_stash
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
