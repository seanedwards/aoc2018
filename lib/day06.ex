defmodule Day06 do
  use Aoc2018, day: 6
  alias Graphmath.Vec2

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x2 - x1) + abs(y2 - y1)
  def dist_pt_to_line(pt, {p1, p2}) do
    v = Vec2.subtract(p2, p1)
    w = Vec2.subtract(pt, p1)

    c1 = Vec2.dot(w, v)
    c2 = Vec2.dot(v, v)
    cond do
      c1 <= 0 -> Vec2.length(Vec2.subtract(pt, p1))
      c2 <= 0 -> Vec2.length(Vec2.subtract(pt, p2))
      true ->
        b = c1/c2
        pb = Vec2.add(p1, Vec2.scale(v, b))
        Vec2.length(Vec2.subtract(pt, pb))
    end
  end

  def quick_hull(pts) do
    pts_sorted = pts |> Enum.sort_by(fn {x, _y} -> x end)
    a = pts_sorted |> hd
    b = pts_sorted |> Enum.reverse() |> hd

    {lhs, rhs} = split_pts(pts, {a, b})
    find_hull(lhs, a, b) ++
    find_hull(rhs, b, a) ++ [a, b]
  end

  def find_hull([], _p, _q), do: []
  def find_hull(pts, p, q) do
    {c, _dist} = pts
    |> Enum.map(fn pt -> {pt, dist_pt_to_line(pt, {p, q})} end)
    |> Enum.sort_by(fn {_pt, dist} -> dist end)
    |> Enum.reverse
    |> hd
    {lhs_pc, rhs_pc} = split_pts(pts, {p, c})
    {lhs_cq, rhs_cq} = split_pts(pts, {c, q})

    [ c | find_hull(lhs_pc, p, c) ++ find_hull(lhs_cq, c, q) ]
  end

  def side({{x1, y1}, {x2, y2}}, {x, y}) do
    # https://math.stackexchange.com/questions/274712/calculate-on-which-side-of-a-straight-line-is-a-given-point-located
    (x-x1) * (y2-y1) - (y-y1) * (x2-x1)
  end

  def split_pts(pts, line) do
    pts
    |> Enum.split_with(fn pt ->
      side(line, pt) < 0
    end)
  end

  def distance_set(coord, destinations) do
    destinations
    |> Enum.map(fn destination -> {destination, manhattan_distance(coord, destination)} end)
    |> Enum.sort_by(fn {_dest, dist} -> dist end)
  end

  def owner_of(coord, destinations) do
    { destination, _distance } = distance_set(coord, destinations) |> hd
    destination
  end

  def destinations() do
    input_as_lines()
    |> Enum.map(fn line ->
      [ x, y ] = String.split(line, ",") |> Enum.map(&String.trim/1)
      { String.to_integer(x), String.to_integer(y) }
    end)
  end

  def walk({x, y}, destinations, infinite_destinations) do
    walk(%{
      coord: {x, y},
      destinations: destinations,
      infinite_destinations: MapSet.new(infinite_destinations)
    }, {x, y}, MapSet.new())
  end

  def walk(state, node, seen) do
    owner = owner_of(node, destinations)
    IO.puts inspect({node, owner, MapSet.size(seen)})
    cond do 
      MapSet.size(seen) > 5000 -> seen
      owner != state.coord -> seen
      MapSet.member?(seen, node)-> seen
      MapSet.member?(state.infinite_destinations, owner) -> seen
      true ->
        seen = seen |> MapSet.put(node)
        [{1,0}, {-1,0}, {0,1}, {0,-1}]
        |> Enum.reduce(seen, fn delta, seen ->
          walk(state, Vec2.add(node, delta), seen)
        end)
    end
  end

  def part_one do
    destinations = Day06.destinations()
    infinite_destinations = Day06.quick_hull(destinations)
    #Day06.walk({237, 217}, destinations, infinite_destinations)

    #destinations |> Enum.each(fn {x, y} -> IO.puts("#{x},#{y}") end)
    #infinite_destinations |> Enum.each(fn {x, y} -> IO.puts("#{x},#{y}") end)

    (destinations -- infinite_destinations)
    |> Enum.map(fn {x, y} ->
      mine = walk({x, y}, destinations, infinite_destinations) |> MapSet.size()
      IO.puts(inspect({{x, y}, mine}))
    end)
    #|> Enum.group_by(fn {coord, owner} -> owner end)
    #|> Enum.sort_by(fn {{_x, _y}, {_owner, dist}} -> dist end)
    #|> Enum.reverse()
    #|> hd
  end
end