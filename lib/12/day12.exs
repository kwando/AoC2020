defmodule Aoc2020.Day12 do
  def part1(input) do
    input
    |> Enum.to_list()

    simulate({{0, 0}, {1, 0}}, Enum.to_list(input))
    |> distance()
  end

  def distance({x, y}), do: abs(x) + abs(y)

  def simulate({pos, dir}, []) do
    pos
  end

  def simulate(state, [instruction | rest]) do
    simulate(execute(instruction, state), rest)
  end

  def execute({:forward, units}, {pos, dir}), do: {translate(pos, scale(dir, units)), dir}
  def execute({:north, units}, {pos, dir}), do: {translate(pos, scale({0, 1}, units)), dir}
  def execute({:south, units}, {pos, dir}), do: {translate(pos, scale({0, -1}, units)), dir}
  def execute({:east, units}, {pos, dir}), do: {translate(pos, scale({1, 0}, units)), dir}
  def execute({:west, units}, {pos, dir}), do: {translate(pos, scale({-1, 0}, units)), dir}
  def execute({:right, units}, {pos, dir}), do: {pos, rotate({:right, units}, dir)}
  def execute({:left, units}, {pos, dir}), do: {pos, rotate({:left, units}, dir)}

  def scale({x, y}, factor) do
    {x * factor, y * factor}
  end

  def translate({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  def rotate({_, 0}, dir), do: dir
  def rotate({:right, n}, dir), do: rotate({:right, n - 1}, rotate(:right, dir))
  def rotate({:left, n}, dir), do: rotate({:left, n - 1}, rotate(:left, dir))
  def rotate(:right, {1, 0}), do: {0, -1}
  def rotate(:right, {0, -1}), do: {-1, 0}
  def rotate(:right, {-1, 0}), do: {0, 1}
  def rotate(:right, {0, 1}), do: {1, 0}
  def rotate(:left, {1, 0}), do: {0, 1}
  def rotate(:left, {0, -1}), do: {1, 0}
  def rotate(:left, {-1, 0}), do: {0, -1}
  def rotate(:left, {0, 1}), do: {-1, 0}

  def input_stream(path) do
    File.stream!(path)
    |> Stream.map(&parse/1)
  end

  def parse(line) do
    line
    |> String.trim()
    |> case do
      "F" <> value -> {:forward, String.to_integer(value)}
      "R" <> value -> {:right, round(String.to_integer(value) / 90)}
      "L" <> value -> {:left, round(String.to_integer(value) / 90)}
      "N" <> value -> {:north, String.to_integer(value)}
      "E" <> value -> {:east, String.to_integer(value)}
      "S" <> value -> {:south, String.to_integer(value)}
      "W" <> value -> {:west, String.to_integer(value)}
    end
  end
end

input = Aoc2020.Day12.input_stream("input.txt")

Aoc2020.Day12.part1(input)
|> IO.inspect(label: "part1")
