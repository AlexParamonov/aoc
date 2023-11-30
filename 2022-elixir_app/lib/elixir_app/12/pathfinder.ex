defmodule ElixirApp.Pathfinder do
  def shortest_path_step_count(raw_input) do
    map = parse_map(raw_input)

    %{start: start, finish: finish} = find_start_and_finish(map)

    map
    |> map_to_graph
    |> find_shortest_path(start, finish)
    |> count_steps
  end

  def shortest_path_from_a_step_count(raw_input) do
    map = parse_map(raw_input)

    [{:finish, finish_location} | start_locations] = find_starts_and_finish(map)

    graph = map_to_graph(map)

    start_locations
    |> Enum.map(fn start ->
      graph
      |> find_shortest_path(start, finish_location)
      |> count_steps
    end)
    |> Enum.min
  end

  defp count_steps(nil), do: :no_path
  defp count_steps(path) do
    Enum.count(path) - 1
  end

  defp parse_map(raw_input) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  defp map_to_graph(map) do
    for i <- 0..(length(map) - 1), j <- 0..(length(hd(map)) - 1) do
      [
        new_node(map, {i, j}, {i, j - 1}),
        new_node(map, {i, j}, {i, j + 1}),
        new_node(map, {i, j}, {i - 1, j}),
        new_node(map, {i, j}, {i + 1, j}),
      ]
    end
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
    |> Enum.reduce(Graph.new(), fn node, graph ->
      Graph.add_edge(graph, node)
    end)
  end

  defp new_node(map, current_position, {i, j} = node_position) when i >= 0 and j >= 0 and i < length(map) and j < length(hd(map)) do
    current_node = node_elevation(map, current_position)
    target_node = node_elevation(map, node_position)

    # dbg("current_node: #{inspect(current_position)}, target_node: #{inspect(node_position)}")
    # dbg("current_node: #{inspect(current_node)}, target_node: #{inspect(target_node)}")
    # dbg(abs(current_node - target_node))

    if (target_node - current_node) <= 1 do
      Graph.Edge.new(current_position, node_position)
    else
      nil
    end
  end
  defp new_node(_, _, _), do: nil

  defp node_elevation(map, {i, j}) do
    map
    |> Enum.at(i)
    |> Enum.at(j)
    |> case do
      83 -> 97
      69 -> 122
      node -> node
    end
  end

  defp find_shortest_path(graph, start_position, end_position) do
    Graph.Pathfinding.dijkstra(graph, start_position, end_position)
  end

  defp find_start_and_finish(map) do
    for i <- 0..(length(map) - 1), j <- 0..(length(hd(map)) - 1) do
      case map |> Enum.at(i) |> Enum.at(j) do
        83 -> {:start, {i, j}}
        69 -> {:finish, {i, j}}
          _ -> nil
      end
    end
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end

  defp find_starts_and_finish(map) do
    for i <- 0..(length(map) - 1), j <- 0..(length(hd(map)) - 1) do
      case map |> Enum.at(i) |> Enum.at(j) do
        83 -> {i, j}
        97 -> {i, j}
        69 -> {:finish, {i, j}}
          _ -> nil
      end
    end
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
    |> Enum.sort
    |> Enum.reverse
  end
end
