defmodule ElixirApp.ElfStashTest do
  use ExUnit.Case
  alias ElixirApp.ElfStash

  alias ElixirApp.FileFixtures

  setup_all do
    stash = FileFixtures.content("1/demo_stash.txt")
    %{stash: stash}
  end

  describe ".top_carrier_calories" do
    test "returns the calories in the top carrier stash", %{stash: stash} do
      assert ElfStash.top_carrier_calories(stash) == 24_000
    end
  end

  describe ".top_group_calories" do
    test "returns the calories in the top carrier's group stash", %{stash: stash} do
      assert ElfStash.top_group_calories(stash, group_size: 3) == 45_000
    end
  end
end
