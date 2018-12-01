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
    |> Stream.scan({0, []}, fn(num, { freq, seen }) -> 
      { freq + num, [ freq + num | seen ] }
    end)
    |> Stream.drop_while(fn({freq, [ _ | seen ] }) -> !Enum.member?(seen, freq) end)
    |> Stream.map(fn({freq, seen}) -> freq end)
    |> Enum.take(1)
    |> hd
  end
end
