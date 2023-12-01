defmodule ElixirApp.TrebuchetBoundary.DecodeHub do
  use GenServer

  alias ElixirApp.TrebuchetCore.{NumericDecoder, UniversalDecoder}

  @type state :: non_neg_integer()

  # Public API

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  @spec decode_words_and_numbers(String.t()) :: non_neg_integer()
  def decode_words_and_numbers(encoded_value) do
    GenServer.call(__MODULE__, {:decode_words_and_numbers, encoded_value})
  end

  @spec decode_numbers(String.t()) :: non_neg_integer()
  def decode_numbers(encoded_value) do
    GenServer.call(__MODULE__, {:decode_numbers, encoded_value})
  end

  # Private API

  @spec init(non_neg_integer()) :: {:ok, state}
  def init(count) do
    {:ok, count}
  end

  @spec handle_call(term, GenServer.from(), state) :: {:reply, term, state}
  def handle_call(message, from, count)

  # it is an atomic and sync operation, so it is safe to use `count + 1`
  def handle_call({:decode_numbers, encoded_value}, _from, count) do
    {
      :reply,
      NumericDecoder.decode(encoded_value),
      count + 1
    }
  end

  def handle_call({:decode_words_and_numbers, encoded_value}, _from, count) do
    {
      :reply,
      UniversalDecoder.decode(encoded_value),
      count + 1
    }
  end
end
