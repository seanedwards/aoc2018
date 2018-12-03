defmodule Day03 do
  use Aoc2018, day: 3

  def parse_claim(line) do
    regex = ~r/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/
    captures = Regex.named_captures(regex, line)
    %{
      id: Integer.parse(captures["id"])  |> elem(0),
      x: %{start: Integer.parse(captures["top"]) |> elem(0), length: Integer.parse(captures["height"]) |> elem(0)},
      y: %{start: Integer.parse(captures["left"]) |> elem(0), length: Integer.parse(captures["width"]) |> elem(0)}
    }
  end

  def dimension_overlap(%{start: start1, length: length1}, %{start: start2, length: length2}) do
    cond do
      # No overlap
      start1 + length1 < start2 -> 0 
      # Partial overlap
      start1 + length1 <= start2 + length2 -> start1 + length1 - start2
      # Fully contained
      start1 + length1 > start2 + length2 -> length2
    end
  end

  def find_overlap(claim1, claim2) do
    {topmost, bottommost} = if claim1.y.start < claim2.y.start, do: {claim1, claim2}, else: {claim2, claim1}
    {leftmost, rightmost} = if claim1.x.start < claim2.x.start, do: {claim1, claim2}, else: {claim2, claim1}

    height_overlap = dimension_overlap(topmost.y, bottommost.y)
    width_overlap = dimension_overlap(leftmost.x, rightmost.x)
    cond do
      height_overlap <= 0 || width_overlap <= 0 -> []
      true ->
        0..height_overlap-1 |> Enum.flat_map(fn(top) ->
          0..width_overlap-1 |> Enum.map(fn(left) ->
            %{
              y: bottommost.y.start + top,
              x: rightmost.x.start + left,
              topmost: topmost,
              bottommost: bottommost,
              height_overlap: height_overlap,
              width_overlap: width_overlap
            }
          end)
        end)
    end
  end

  def claims do
    input_as_lines()
    |> Enum.map(&parse_claim/1)
    
  end

  def overlaps(claims) do
    claims
    |> Aoc2018.pairwise()
    |> Enum.flat_map(fn({lhs, rhs}) -> find_overlap(lhs, rhs) end)
  end

  def part_one do
    overlaps(claims())
    |> Stream.reduce(%{}, fn(overlap, acc) -> acc
      |> Map.get_and_update("#{overlap.x},#{overlap.y}", fn
        nil -> {nil, 1}
        current_value -> {current_value, current_value + 1}
      end)
      |> elem(1)
    end)
    |> Enum.count()
  end

  def part_two do
    claims = claims()
    overlaps = overlaps(claims)
    |> Stream.flat_map(&( [ &1.topmost.id, &1.bottommost.id ] ))
    |> Enum.uniq()

    claims = claims
    |> Stream.map(&(&1.id))
    |> Stream.filter(fn id ->
       overlaps
       |> Stream.filter(&( id == &1 ))
       |> Enum.count() == 0
    end)
    |> Enum.take(1)
  end
end
