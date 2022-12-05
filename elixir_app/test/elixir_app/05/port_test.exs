defmodule ElixirApp.PortTest do
  use ExUnit.Case
  alias ElixirApp.Port

  alias ElixirApp.FileFixtures

  setup_all do
    raw_input = FileFixtures.content("05/demo_pile.txt")
    %{raw_input: raw_input}
  end

  describe ".sort_crates" do
    test "returns the crates on the top of the pile", %{raw_input: raw_input} do
      assert Port.sort_crates(raw_input, using: :model_9000) == "CMZ"
    end

    test "returns the crates on the top of the pile when using model 9001", %{raw_input: raw_input} do
      assert Port.sort_crates(raw_input, using: :model_9001) == "MCD"
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("05/pile.txt")
      %{raw_input: raw_input}
    end

    test "returns the crates on the top of the pile", %{raw_input: raw_input} do
      assert Port.sort_crates(raw_input, using: :model_9000) == "DHBJQJCCW"
    end

    test "returns the crates on the top of the pile when using model 9001", %{raw_input: raw_input} do
      assert Port.sort_crates(raw_input, using: :model_9001) == "WJVRLSJJT"
    end
  end
end
