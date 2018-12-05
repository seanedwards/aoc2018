defmodule Day05 do
  use Aoc2018, day: 5
  use Bitwise

  def unit(item), do: (item ||| 32) # lowercase version of letter
  def polarity(item), do: (item ||| 32) == item # uppercase: false, lowercase: true

  def react(polymer) do
    polymer
    |> Enum.reduce([], fn
      char, [] -> [ char | [] ]
      a, [b | tail] -> if (unit(a) == unit(b) && polarity(a) == !polarity(b)) do
        tail
      else
        [a | [ b | tail ]]
      end
    end)
  end

  def part_one do
    input()
    |> String.to_charlist
    |> react()
    |> Enum.count()
  end

  def part_two do
    polymer = input()
    |> String.to_charlist
    for letter <- ?a..?z,
      filtered_polymer = polymer |> Enum.filter(&(unit(&1) != letter)) |> react()
    do
      Enum.count(filtered_polymer)
    end
    |> Enum.sort()
    |> hd
  end
end