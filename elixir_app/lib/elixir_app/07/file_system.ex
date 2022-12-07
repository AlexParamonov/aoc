defmodule ElixirApp.FileSystem do
  defmodule Dir do
    defstruct [:name, :children]
  end

  defmodule File do
    defstruct [:name, :size]
  end

  def load_from_command_log(raw_input) do
    load_from_command_log(raw_input, current_dir: %Dir{name: "/", children: []})
  end

  def load_from_command_log(raw_input, current_dir: current_dir) do
    raw_input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> load_instructions
    |> execute_instructions(current_dir)
  end

  def filter_dir(_fs, max_size: _max_size) do
    []
  end

  def size(%Dir{children: _children}) do
    0
  end

  defp command?(line) do
    String.starts_with?(line, "$")
  end

  defp load_instructions(list) do
    Enum.reduce(list, [:done], fn line, [head | tail] = acc ->
      if command?(line) do
        [load_command(line) | acc]
      else
        [put_elem(head, 1, [line | elem(head, 1)]) | tail]
      end
    end)
  end

  defp load_command("$ ls"), do: {:ls, []}
  defp load_command("$ cd " <> name), do: {:cd, name}

  defp execute_instructions(instructions, current_dir) do
    instructions
    |> Enum.reverse()
    |> Enum.slice(1..-1)
    |> Enum.reduce(%{current_dir: current_dir, path: [current_dir.name], root: current_dir}, fn command, tree ->
      execute_instruction(command, tree)
    end)
    |> Map.get(:root)
  end

  defp execute_instruction({:cd, ".."}, tree) do
    new_path = Enum.slice(tree.path, 0..-2)
    new_dir = find_dir(tree.root, at: new_path)

    Map.merge(tree, %{
      current_dir: new_dir,
      path: new_path
    })
  end

  defp execute_instruction({:cd, name}, %{current_dir: current_dir} = tree) do
    new_dir =
      current_dir.children
      |> Enum.find(fn child -> child.name == name end)

    Map.merge(tree, %{
      current_dir: new_dir,
      # path: [new_dir.name | tree.path]
      path: [tree.path] ++ [new_dir.name]
    })
  end

  defp execute_instruction({:ls, result}, %{current_dir: current_dir, root: root} = tree) do
    entries = load_entries(result)
    current_dir = Map.put(current_dir, :children, entries)

    Map.merge(tree, %{
      current_dir: current_dir,
      root: update_root(root, current_dir, at: tree.path)
    })
  end

  defp update_root(_root, dir, at: [_name]), do: dir
  defp update_root(root, dir, at: [_name | [child_name | _rest] = child_path]) do
    updated_list =
      root.children
      |> Enum.map(fn child ->
        if child.name == child_name do
          update_root(child, dir, at: child_path)
        else
          child
        end
      end)

    Map.put(root, :children, updated_list)
  end

  defp find_dir(root, at: [_name]), do: root
  defp find_dir(root, at: [_name | [child_name | _rest] = child_path]) do
    Enum.find(root.children, & &1.name == child_name)
    |> find_dir(at: child_path)
  end

  defp load_entries(list) do
    list
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split()
      |> load_entry
    end)
  end

  defp load_entry(["dir", name]) do
    %Dir{name: name, children: []}
  end

  defp load_entry([size, name]) do
    %File{name: name, size: String.to_integer(size)}
  end
end
