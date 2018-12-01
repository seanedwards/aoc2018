defmodule Day01 do
  use Aoc2018, day: 1

  def input_as_numbers do
    String.split(input(), "\r\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
  end

  def part_one do
    input_as_numbers()
    |> Enum.sum
  end

  def part_two do
    input_as_numbers()
    |> Stream.cycle
    |> Stream.scan([], &Day01.accumulator/2)
    |> Stream.drop_while(fn([ freq | seen ]) -> !Enum.member?(seen, freq) end)
    |> Stream.map(&hd/1)
    |> Enum.take(1)
    |> hd
  end

  def accumulator(num, [ freq | seen ]), do: [ freq + num, freq ] ++ seen
  def accumulator(num, _), do: [ num ]
end
