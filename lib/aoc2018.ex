defmodule Aoc2018 do
  defmacro __using__(day: day) when is_integer(day) do
    quote do
      @day unquote(day)
      import Aoc2018

      def input do
        day = @day
        File.read!("priv/day#{String.pad_leading(to_string(day), 2, "0")}.txt")
      end

      def input_as_lines do
        String.split(input(), "\n")
        |> Enum.map(fn(line) -> String.trim(line, "\r") end)
        |> Enum.filter(&(&1 != ""))
      end

      def output(data) do
        day = @day
        File.write!("priv/day#{String.pad_leading(to_string(day), 2, "0")}/output.txt", data)
      end

    end
  end


  def pairwise(list), do: pairwise(list, [])
  def pairwise([ last ], ret), do: ret
  def pairwise([ lhs | tail ], ret) do
    pairwise(tail, (tail |> Enum.map(fn(rhs) -> { lhs, rhs } end)) ++ ret)
  end
end
