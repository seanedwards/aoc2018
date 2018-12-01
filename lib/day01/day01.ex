defmodule Day01 do
  use Aoc2018, day: 1

  def inputAsNumbers do
    String.split(input(), "\n")
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&String.to_integer/1)
  end

  def partOne do
    inputAsNumbers()
    |> Enum.sum
  end

  def partTwo do
    inputAsNumbers()
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
