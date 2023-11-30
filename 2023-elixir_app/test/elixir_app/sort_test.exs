defmodule ElixirApp.SortTest do
  use ExUnit.Case
  alias ElixirApp.Sort

  test "greets the world" do
    assert Sort.sort([3, 2, 1]) == [1, 2, 3]
  end
end
