defmodule ElixirApp.FileSystemTest do
  use ExUnit.Case, async: true

  alias ElixirApp.FileSystem

  describe ".load_from_command_log" do
    test "loads file list" do
      current_dir = %FileSystem.Dir{name: "test_dir"}

      log = """
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k
      """

      fs = FileSystem.load_from_command_log(log, current_dir: current_dir)

      assert fs.children == [
               %FileSystem.File{name: "k", size: 7_214_296},
               %FileSystem.File{name: "d.ext", size: 5_626_152},
               %FileSystem.File{name: "d.log", size: 8_033_020},
               %FileSystem.File{name: "j", size: 4_060_174}
             ]
    end

    test "loads files and directories" do
      current_dir = %FileSystem.Dir{name: "test_dir"}

      log = """
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
      """

      fs = FileSystem.load_from_command_log(log, current_dir: current_dir)

      assert fs.children == [
               %FileSystem.Dir{name: "d", children: []},
               %FileSystem.File{name: "c.dat", size: 8_504_156},
               %FileSystem.File{name: "b.txt", size: 14_848_514},
               %FileSystem.Dir{name: "a", children: []}
             ]
    end

    test "nested list" do
      current_dir = %FileSystem.Dir{name: "test_dir"}

      log = """
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
      """

      fs = FileSystem.load_from_command_log(log, current_dir: current_dir)

      assert fs.children == [
               %FileSystem.Dir{name: "d", children: []},
               %FileSystem.File{name: "c.dat", size: 8_504_156},
               %FileSystem.File{name: "b.txt", size: 14_848_514},
               %FileSystem.Dir{
                 name: "a",
                 children: [
                   %FileSystem.File{name: "h.lst", size: 62_596},
                   %FileSystem.File{name: "g", size: 2_557},
                   %FileSystem.File{name: "f", size: 29_116},
                   %FileSystem.Dir{name: "e", children: []}
                 ]
               }
             ]
    end

    test "navigate one level up" do
      current_dir = %FileSystem.Dir{name: "test_dir"}

      log = """
        $ ls
        dir a
        14848514 b.txt
        dir d
        $ cd a
        $ ls
        29116 f
        $ cd ..
        $ cd d
        $ ls
        4060174 j
      """

      fs = FileSystem.load_from_command_log(log, current_dir: current_dir)

      assert fs.children == [
               %FileSystem.Dir{
                 name: "d",
                 children: [
                   %FileSystem.File{name: "j", size: 4_060_174}
                 ]
               },
               %FileSystem.File{name: "b.txt", size: 14_848_514},
               %FileSystem.Dir{
                 name: "a",
                 children: [
                   %FileSystem.File{name: "f", size: 29_116}
                 ]
               }
             ]
    end
  end

  describe ".flatten" do
    test "returns all dirs and files" do
      assert %FileSystem.Dir{
               name: "test_dir",
               children: [
                 %FileSystem.Dir{
                   name: "a",
                   children: [
                     %FileSystem.File{name: "f", size: 29_116}
                   ]
                 },
                 %FileSystem.File{name: "b.txt", size: 14_848_514},
                 %FileSystem.Dir{
                   name: "d",
                   children: [
                     %FileSystem.File{name: "j", size: 4_060_174}
                   ]
                 },
                 %FileSystem.Dir{
                   name: "empty",
                   children: []
                 }
               ]
             }
             |> FileSystem.flatten()
             |> Enum.map(& &1.name) == ["a", "f", "b.txt", "d", "j", "empty"]
    end
  end

  describe ".filter_dir" do
    test "returns only dirs" do
      assert %FileSystem.Dir{
               name: "test_dir",
               children: [
                 %FileSystem.Dir{
                   name: "a",
                   children: [
                     %FileSystem.File{name: "f", size: 29_116}
                   ]
                 },
                 %FileSystem.File{name: "b.txt", size: 14_848_514},
                 %FileSystem.Dir{name: "empty", children: []}
               ]
             }
             |> FileSystem.filter_dir()
             |> Enum.map(& &1.name) == ["a", "empty"]
    end

    test "returns only dirs smaller than max_size" do
      assert %FileSystem.Dir{
               name: "test_dir",
               children: [
                 %FileSystem.Dir{
                   name: "a",
                   children: [
                     %FileSystem.File{name: "f", size: 29_116}
                   ]
                 },
                 %FileSystem.File{name: "b.txt", size: 14_848_514},
                 %FileSystem.Dir{
                   name: "c",
                   children: [
                     %FileSystem.File{name: "huge", size: 1_000_000_000}
                   ]
                 },
                 %FileSystem.Dir{name: "empty", children: []}
               ]
             }
             |> FileSystem.filter_dir(max_size: 300_000)
             |> Enum.map(& &1.name) == ["a", "empty"]
    end
  end
end
