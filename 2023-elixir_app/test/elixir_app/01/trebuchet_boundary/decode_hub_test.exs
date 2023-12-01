defmodule ElixirApp.TrebuchetBoundary.DecodeHubTest do
  use ExUnit.Case, async: false

  alias ElixirApp.TrebuchetBoundary.DecodeHub

  setup do
    assert {:ok, _pid} = start_supervised(DecodeHub)
    :ok
  end

  test "decodes a line with numbers" do
    assert 24 = DecodeHub.decode_numbers("2aousntd3oauao4")
  end

  test "decodes a line with words and numbers" do
    assert 27 = DecodeHub.decode_words_and_numbers("2aousntd3oauao4seven")
  end

  test "increments decode_operations_count" do
    DecodeHub.decode_words_and_numbers("2aousntd3oauao4seven")
    assert 1 = DecodeHub.decode_operations_count()
  end
end
