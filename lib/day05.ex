defmodule Day05 do
  use Aoc2018, day: 5
  use Bitwise

  def unit(item), do: (item ||| 32) # lowercase version of letter
  def polarity(item), do: (item ||| 32) == item # uppercase: false, lowercase: true

  def react(a, b), do: cond do
    unit(a) == unit(b) && polarity(a) == !polarity(b) -> []
    true -> [a, b]
  end
  def react([], acc), do: acc
  def react(list) do
    [head | tail] = list
    Enum.zip
  end
  end


  def part_one do
    poly = input() |> String.to_charlist
    react(poly, [])
  end
end