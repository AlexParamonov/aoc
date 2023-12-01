defmodule ElixirApp.TrebuchetBoundary.DecodeHub do
  use GenServer

  alias ElixirApp.TrebuchetCore.{NumericDecoder, UniversalDecoder}

  @type state :: non_neg_integer()

  # Public API

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    name = opts[:name] || __MODULE__
    GenServer.start_link(__MODULE__, 0, name: name)
  end

  @spec decode_words_and_numbers(GenServer.name(), String.t()) :: non_neg_integer()
  def decode_words_and_numbers(server \\ __MODULE__, encoded_value) do
    GenServer.call(server, {:decode_words_and_numbers, encoded_value})
  end

  @spec decode_numbers(GenServer.name(), String.t()) :: non_neg_integer()
  def decode_numbers(server \\ __MODULE__, encoded_value) do
    GenServer.call(server, {:decode_numbers, encoded_value})
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
