defmodule Day04 do
  use Aoc2018, day: 4

  # I hate all of this.

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
    |> Enum.map(fn [{time_asleep, guard_id, :sleep}, {time_awake, _, :wake}] -> %{
      guard: guard_id,
      minutes_asleep: NaiveDateTime.diff(time_awake, time_asleep, :second) / 60,
      sleep: time_asleep,
      wake: time_awake
    } end)
  end

  def part_one do
    schedule = schedule() 
    schedule_by_guard = schedule 
    |> Enum.group_by(fn %{ guard: guard } -> guard end)

    { sleepiest_guard, minutes_asleep } = schedule_by_guard
    |> Enum.map(fn {guard, naps} -> {guard, (for nap <- naps, do: nap.minutes_asleep)} end)
    |> Enum.map(fn {guard, list} -> { guard, list |> Enum.sum() } end)
    |> Enum.sort_by(&(&1 |> elem(1)))
    |> Enum.reverse()
    |> hd

    nap_minutes = for minute <- 0..59,
      count = schedule_by_guard[sleepiest_guard]
      |> Enum.filter(fn %{sleep: sleep_time, wake: wake_time} -> minute >= sleep_time.minute && minute < wake_time.minute end) |> Enum.count() do
        {minute, count}
      end

    most_common_minute = nap_minutes
    |> Enum.sort_by(&(&1 |> elem(1)))
    |> Enum.reverse()
    |> hd |> elem(0)

    sleepiest_guard * most_common_minute
  end

  def part_two do
    {guard, minute, _} = 
    for minute <- 0..59 do
      items = schedule
      |> Enum.group_by(fn %{ guard: guard } -> guard end) |> Map.to_list()
      |> Enum.map(fn { guard, items } -> {
        guard,
        minute,
        items
        |> Enum.filter(fn event -> minute >= event.sleep.minute && minute < event.wake.minute end)
        |> Enum.count()
      } end)
      |> Enum.sort_by(fn {_, _, items} -> items end) 
      |> Enum.reverse()
      |> hd
    end
    |> Enum.sort_by(fn {_, _, items} -> items end) 
    |> Enum.reverse()
    |> hd
  
    guard * minute
  end

end