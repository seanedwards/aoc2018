defmodule Aoc2018 do
  defmacro __using__(day: day) when is_integer(day) do
    quote do
      @day unquote(day)
      import Aoc2018

      def input do
        day = @day
        File.read!("priv/day#{String.pad_leading(to_string(day), 2, "0")}/input.txt")
      end

      def output(data) do
        day = @day
        File.write!("priv/day#{String.pad_leading(to_string(day), 2, "0")}/output.txt", data)
      end
    end
  end
end
