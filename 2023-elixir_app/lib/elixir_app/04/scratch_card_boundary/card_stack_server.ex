defmodule ElixirApp.ScratchCardBoundary.CardStackServer do
  @cards_table :scratch_cards
  @winning_cards_table :winning_scratch_cards

  use GenServer

  alias ElixirApp.ScratchCardCore

  @type state :: non_neg_integer()

  # Public API

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  # Returns genserver state
  def uniq_cards_count do
    GenServer.call(__MODULE__, :uniq_cards_count)
  end

  @spec load_cards(list(ScratchCardCore.Card.t())) :: non_neg_integer()
  def load_cards(cards) do
    GenServer.call(__MODULE__, {:load_cards, cards})
    cards
  end

  @spec use_card(ScratchCardCore.Card.t()) :: non_neg_integer()
  def use_card(card) do
    GenServer.call(__MODULE__, {:use_card, card})
  end

  def winning_cards do
    :ets.tab2list(@winning_cards_table)
  end

  # Private API

  @spec init(non_neg_integer()) :: {:ok, state}
  def init(count) do
    :ets.new(@cards_table, [:ordered_set, :protected, :named_table])
    :ets.new(@winning_cards_table, [:ordered_set, :protected, :named_table])

    {:ok, count}
  end

  @spec handle_call(term, GenServer.from(), state) :: {:reply, term, state}
  def handle_call(message, from, count)

  def handle_call({:load_cards, cards}, _from, _count) do
    Enum.each(cards, fn card ->
      :ets.insert(@cards_table, {card.id, card})
      :ets.insert(@winning_cards_table, {card.id, {nil, 1}})
    end)

    {:reply, :ok, length(cards)}
  end

  def handle_call({:use_card, %{id: current_card_id}}, _from, count) do
    case :ets.lookup(@cards_table, current_card_id) do
      [{^current_card_id, card}] ->
        :ets.tab2list(@winning_cards_table)
        |> ScratchCardCore.CardRules.cards_won(card)
        |> Enum.each(fn {id, data} ->
          :ets.insert(@winning_cards_table, {id, data})
        end)

        {:reply, :ok, count}


      [] -> {:reply, :error, count}
    end
  end

  def handle_call(:uniq_cards_count, _from, count), do: count
end
