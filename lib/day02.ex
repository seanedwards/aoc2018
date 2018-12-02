defmodule Day02 do
  use Aoc2018, day: 2

  def part_one do
    data = input_as_lines()
    twos = data |> Enum.filter(fn(line) -> Regex.match?(~r/.*([a-z]).*\1.*/, line) end) |> Enum.count()
    threes = data |> Enum.filter(fn(line) -> Regex.match?(~r/.*([a-z]).*\1.*\1.*/, line) end) |> Enum.count()

    twos * threes
  end

  def part_two do
    data = input_as_lines() |> Enum.map(&String.to_charlist/1)

    {lhs, rhs} = data 
    |> Enum.flat_map(fn(item1) -> data |> Enum.map(fn(item2) -> {item1, item2} end) end)
    |> Enum.find(fn({item1, item2}) ->
      Enum.zip(item1, item2) 
      |> Enum.filter(fn({lhs, rhs}) -> lhs != rhs end)
      |> Enum.count() == 1
    end)

    Enum.zip(lhs, rhs)
    |> Enum.filter(fn({lhs, rhs}) -> lhs == rhs end)
    |> Enum.map(fn({lhs, _}) -> lhs end)
  end
end
