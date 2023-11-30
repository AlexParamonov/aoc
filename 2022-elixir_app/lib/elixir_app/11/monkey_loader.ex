defmodule ElixirApp.MonkeyLoader do
  alias ElixirApp.Monkey

  def load(raw_definition) do
    raw_definition
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> load_definition()
  end

  defp load_definition([raw_id, raw_starting_items, raw_operation | raw_conditions]) do
    %Monkey{
      id: load_id(raw_id),
      items: load_starting_items(raw_starting_items),
      operation_fn: load_operation(raw_operation),
      condition_fn: load_conditions(raw_conditions),
      inspect_count: 0
    }
  end

  defp load_id("Monkey " <> id) do
    id
    |> String.trim(":")
    |> String.to_integer()
  end

  defp load_starting_items(raw_starting_items) do
    raw_starting_items
    |> String.split(":")
    |> List.last()
    |> String.trim()
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
  end

  defp load_operation(raw_operation) do
    raw_operation
    |> String.split("=")
    |> List.last()
    |> String.trim()
    |> String.split()
    |> build_operation()
  end

  defp load_conditions([
         "Test: divisible by " <> divisible_by,
         "If true: throw to monkey " <> positive_destination,
         "If false: throw to monkey " <> negative_destination
       ]) do
    fn item ->
      if rem(item, String.to_integer(divisible_by)) == 0 do
        String.to_integer(positive_destination)
      else
        String.to_integer(negative_destination)
      end
    end
  end

  defp build_operation(["old", operator, "old"]), do: &execute_operation(&1, operator, &1)
  defp build_operation(["old", operator, val]), do: &execute_operation(&1, operator, String.to_integer(val))
  defp execute_operation(val1, "+", val2), do: val1 + val2
  defp execute_operation(val1, "*", val2), do: val1 * val2
end
