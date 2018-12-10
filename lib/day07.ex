defmodule Day07 do
  use Aoc2018, day: 7

  def parse_instruction(line) do
    r = ~r/Step (?<dep>[A-Z]) must be finished before step (?<id>[A-Z]) can begin./
    caps = Regex.named_captures(r, line)
    %{
      id: caps["id"],
      dep: caps["dep"]
    }
  end

  def execute(dep_list, ret \\ "") do
    exec_char = ?A..?Z
    |> Enum.find(fn c ->
      c = <<c::utf8>>
      !String.contains?(ret, c) &&
      Enum.all?(dep_list, fn it -> it.id != c end)
    end)

    if exec_char == nil do
      ret
    else
      exec_char = <<exec_char::utf8>>
      ret = ret <> exec_char
      dep_list = dep_list
      |> Enum.filter(fn %{dep: d} -> d != exec_char end)
      execute(dep_list, ret)
    end
  end

  def execute_parallel(dep_list, wip \\ %{}, finished_at \\ %{}) do
    ready = ?A..?Z
    |> Enum.filter(fn c ->
      c = <<c::utf8>>
      
      Map.get(finished_at, c) == nil &&
      Enum.all?(dep_list, fn it -> it.id != c end)
    end)

    if exec_char == nil do
      ret
    else
      exec_char = <<exec_char::utf8>>
      ret = ret <> exec_char
      dep_list = dep_list
      |> Enum.filter(fn %{dep: d} -> d != exec_char end)
      execute(dep_list, ret)
    end
  end

  def part_one do
    input_as_lines()
    |> Enum.map(&Day07.parse_instruction/1)
    |> Enum.sort_by(fn it -> it.id end)
    |> Day07.execute
  end
end