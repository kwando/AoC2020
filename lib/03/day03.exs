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
    count_trees(input, 3)
  end

  def part2(input) do
    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    for {dx, dy} <- slopes do
      count_trees(input, dx)
    end
  end

  def count_trees(input, shift_amount) do
    input
    |> Stream.map(&Stream.cycle/1)
    |> Enum.reduce({0, 0}, fn
      row, {trees, shift} ->
        row
        |> Stream.drop(shift)
        |> Enum.take(1)
        |> case do
          ["."] ->
            {trees, shift + shift_amount}

          ["#"] ->
            {trees + 1, shift + shift_amount}
        end
    end)
    |> elem(0)
  end
end

input = Aoc2020.Day03.input_stream("example.txt")

input
|> Aoc2020.Day03.part1()
|> IO.inspect(label: "part1")

input
|> Aoc2020.Day03.part2()
|> IO.inspect(label: "part2")
