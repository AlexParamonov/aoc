defmodule ElixirApp.MonkeyBusinessTest do
  use ExUnit.Case, async: true

  alias ElixirApp.MonkeyBusiness
  alias ElixirApp.FileFixtures
  use FlowAssertions

  setup_all do
    raw_input = FileFixtures.content("11/demo_monkeys.txt")
    %{raw_input: raw_input}
  end

  describe ".calculate_level" do
    test "calculates the monkey_business_level after x rounds", %{raw_input: raw_input} do
      assert MonkeyBusiness.calculate_level(raw_input, rounds: 20) == 10_605
    end
  end

  describe ".play" do
    test "plays a round", %{raw_input: raw_input} do
      assert MonkeyBusiness.play(raw_input, rounds: 1)
             |> Enum.map(fn
               {0, monkey} ->
                 assert_fields(monkey, %{
                   items: [20, 23, 27, 26]
                 })
               {1, monkey} ->
                 assert_fields(monkey, %{
                   items: [2080, 25, 167, 207, 401, 1046]
                 })
               {2, monkey} ->
                 assert_fields(monkey, %{
                   items: []
                 })
               {3, monkey} ->
                 assert_fields(monkey, %{
                   items: []
                 })
             end)
    end

    test "plays 8 rounds", %{raw_input: raw_input} do
      assert MonkeyBusiness.play(raw_input, rounds: 8)
             |> Enum.map(fn
               {0, monkey} ->
                 assert_fields(monkey, %{
                   items: [51, 126, 20, 26, 136]
                 })
               {1, monkey} ->
                 assert_fields(monkey, %{
                   items: [343, 26, 30, 1546, 36]
                 })
               {2, monkey} ->
                 assert_fields(monkey, %{
                   items: []
                 })
               {3, monkey} ->
                 assert_fields(monkey, %{
                   items: []
                 })
             end)
    end

    test "plays 20 rounds", %{raw_input: raw_input} do
      assert MonkeyBusiness.play(raw_input, rounds: 20)
             |> Enum.map(fn
               {0, monkey} ->
                 assert_fields(monkey, %{
                   items: [10, 12, 14, 26, 34],
                   inspect_count: 101
                 })
               {1, monkey} ->
                 assert_fields(monkey, %{
                   items: [245, 93, 53, 199, 115],
                   inspect_count: 95
                 })
               {2, monkey} ->
                 assert_fields(monkey, %{
                   items: [],
                   inspect_count: 7
                 })
               {3, monkey} ->
                 assert_fields(monkey, %{
                   items: [],
                   inspect_count: 105
                 })
             end)
    end
  end

  describe "result" do
    setup do
      raw_input = FileFixtures.content("11/monkeys.txt")
      %{raw_input: raw_input}
    end

    test "calculates the monkey_business_level after 20 rounds", %{raw_input: raw_input} do
      assert MonkeyBusiness.calculate_level(raw_input, rounds: 20) == 10_605
    end

    @tag timeout: :infinity
    test "calculates the monkey_business_level after 10_000 rounds", %{raw_input: raw_input} do
      assert MonkeyBusiness.calculate_level(raw_input, rounds: 10_000) == 10_605
    end
  end

end
