defmodule Aoc2020.Day12 do
  def part1(input) do
    simulate({{0, 0}, {1, 0}}, input)
    |> distance()
  end

  def part2(input) do
    simulate_waypoint({{0, 0}, {10, 1}}, input)
    |> distance()
  end

  def simulate_waypoint(state, instructions) do
    for instruction <- instructions, reduce: state do
      {ship, waypoint} ->
        case instruction do
          {:forward, value} ->
            {translate(ship, scale(waypoint, value)), waypoint}

          {:move, vector} ->
            {ship, translate(waypoint, vector)}

          {:right, times} ->
            {ship, rotate({:right, times}, waypoint)}

          {:left, times} ->
            {ship, rotate({:left, times}, waypoint)}
        end
    end
    |> elem(0)
  end

  def simulate(state, instructions) do
    for instruction <- instructions, reduce: state do
      {pos, dir} ->
        case instruction do
          {:forward, units} -> {translate(pos, scale(dir, units)), dir}
          {:left, units} -> {pos, rotate({:left, units}, dir)}
          {:right, units} -> {pos, rotate({:right, units}, dir)}
          {:move, vector} -> {translate(pos, vector), dir}
        end
    end
    |> elem(0)
  end

  def distance({x, y}), do: abs(x) + abs(y)

  def scale({x, y}, factor), do: {x * factor, y * factor}
  def translate({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  def rotate({_, 0}, dir), do: dir
  def rotate({:right, n}, dir), do: rotate({:right, n - 1}, rotate(:right, dir))
  def rotate({:left, n}, dir), do: rotate({:left, n - 1}, rotate(:left, dir))
  def rotate(:left, {x, y}), do: {-y, x}
  def rotate(:right, {x, y}), do: {y, -x}

  def input_stream(path) do
    File.stream!(path)
    |> Stream.map(&parse/1)
  end

  def direction(:north), do: {0, 1}
  def direction(:east), do: {1, 0}
  def direction(:west), do: {-1, 0}
  def direction(:south), do: {0, -1}

  def parse(line) do
    line
    |> String.trim()
    |> case do
      "F" <> value -> {:forward, String.to_integer(value)}
      "R" <> value -> {:right, round(String.to_integer(value) / 90)}
      "L" <> value -> {:left, round(String.to_integer(value) / 90)}
      "N" <> value -> {:move, scale(direction(:north), String.to_integer(value))}
      "E" <> value -> {:move, scale(direction(:east), String.to_integer(value))}
      "S" <> value -> {:move, scale(direction(:south), String.to_integer(value))}
      "W" <> value -> {:move, scale(direction(:west), String.to_integer(value))}
    end
  end
end

input = Aoc2020.Day12.input_stream("input.txt")

Aoc2020.Day12.part1(input)
|> IO.inspect(label: "part1")

Aoc2020.Day12.part2(input)
|> IO.inspect(label: "part2")
