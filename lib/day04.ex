defmodule Day04 do
  use Aoc2018, day: 4

  def parse_line(line) do
    regex = ~r/\[(?<year>\d\d\d\d)-(?<month>\d\d)-(?<day>\d\d) (?<hour>\d\d):(?<minute>\d\d)\] (?<instruction>.+)/
    captures = Regex.named_captures(regex, line)
    args = captures
    |> Map.take(["year", "month", "day", "hour", "minute"])
    |> Map.to_list()
    |> Enum.map(fn {key, val} -> 
      val = String.to_integer(val) 
      {String.to_atom(key), val}
    end)
    %{
      time: Kernel.struct(NaiveDateTime, args ++ [ second: 0 ]),
      instruction: captures["instruction"]
    }
  end

  def parse_instruction(head, guard, list) do
    case(head.instruction) do
      "falls asleep" -> {guard, list ++ [ {head.time, guard, :sleep} ]}
      "wakes up" -> {guard, list ++ [ {head.time, guard, :wake} ]}
      _ ->
        captures = Regex.named_captures(~r/Guard #(?<id>\d+) begins shift/, head.instruction)
        {guard, _} = Integer.parse(captures["id"])
        {guard, list}
    end
  end

  def parse_instructions([ head ], guard, list) do
    {guard, list} = parse_instruction(head, guard, list)
    list
  end

  def parse_instructions([ head | tail ], guard, list) do
    {guard, list} = parse_instruction(head, guard, list)
    parse_instructions(tail, guard, list)
  end

  def schedule() do
    instructions = input_as_lines()
    |> Enum.map(&parse_line/1)
    |> Enum.sort_by(&({&1.time.year, &1.time.month, &1.time.day, &1.time.hour, &1.time.minute}))
    |> parse_instructions(nil, []) |> Enum.chunk_every(2)
  end

  def part_one do
    naps = schedule() 

    { sleepiest_guard, minutes_asleep } = naps
    |> Enum.map(fn [sleep, wake] -> { sleep |> elem(1), NaiveDateTime.diff(wake |> elem(0), sleep |> elem(0), :second)} end)
    |> Enum.group_by(fn {guard, _} -> guard end)
    |> Enum.map(fn {guard, naps} -> {guard, (for nap <- naps, do: elem(nap, 1))} end)
    |> Enum.map(fn {guard, list} -> { guard, list |> Enum.sum() } end)
    |> Enum.sort_by(&(&1 |> elem(1)))
    |> Enum.reverse()
    |> hd
    
    naps = naps
    |> Enum.filter(fn [{_, guard, :sleep}, {_, guard, :wake}] -> guard == sleepiest_guard end)

    nap_minutes = for minute <- 0..59,
      count = naps |> Enum.filter(fn [{sleep_time, _, :sleep}, {wake_time, _, :wake}] -> minute >= sleep_time.minute && minute < wake_time.minute end) |> Enum.count() do
        {minute, count}
      end
    most_common_minute = nap_minutes |> Enum.sort_by(&(&1 |> elem(1)))
    |> Enum.reverse()
    |> hd |> elem(0)
    sleepiest_guard * most_common_minute
  end

end