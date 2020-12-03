defmodule Aoc2020.Day03 do
  def input_stream(path) do
    File.stream!(path)
    |> Stream.map(&parse/1)
  end

  defp parse(line) do
    line
    |> String.trim()
    |> String.codepoints()
  end

  def part1(input) do
    count_trees(input, {3, 1})
  end

  def part2(input) do
    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    for slope <- slopes, reduce: 1 do
      product -> product * count_trees(input, slope)
    end
  end

  def count_trees(input, {dx, dy}) do
    input
    |> Stream.take_every(dy)
    |> Stream.map(&Stream.cycle/1)
    |> Enum.reduce({0, 0}, fn
      row, {trees, shift} ->
        row
        |> Stream.drop(shift)
        |> Enum.take(1)
        |> case do
          ["."] ->
            {trees, shift + dx}

          ["#"] ->
            {trees + 1, shift + dx}
        end
    end)
    |> elem(0)
  end
end

input = Aoc2020.Day03.input_stream("input.txt")

input
|> Aoc2020.Day03.part1()
|> IO.inspect(label: "part1")

input
|> Aoc2020.Day03.part2()
|> IO.inspect(label: "part2")
