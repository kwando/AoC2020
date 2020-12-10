defmodule Aoc2020.Day10 do
  def part1(numbers) do
    numbers = Enum.sort(numbers, :desc)
    numbers = [hd(numbers) + 3 | numbers]

    diffs =
      numbers
      |> differences()
      |> Enum.frequencies()

    diffs[1] * diffs[3]
  end

  def differences([a]), do: [a]

  def differences([a | [b | _] = rest]) do
    [a - b | differences(rest)]
  end

  def input_stream(path) do
    File.stream!(path)
    |> Stream.map(&parse/1)
  end

  def parse(line) do
    line
    |> String.trim()
    |> String.to_integer()
  end
end

input = Aoc2020.Day10.input_stream("input.txt")

Aoc2020.Day10.part1(input)
|> IO.inspect(label: "part1")
