defmodule Aoc2020.Day05 do
  def part1(input) do
    input_stream("input.txt")
    |> Stream.map(&seat_id/1)
    |> Enum.max()
  end

  def seat_id(spec) when is_binary(spec) do
    {rows, cols} = String.split_at(spec, 7)
    seat_id({decode(rows, ?F, ?B, {0, 127}), decode(cols, ?L, ?R, {0, 7})})
  end

  def seat_id({row, col}) do
    row * 8 + col
  end

  def decode(<<left>>, left, right, {min, max}), do: min
  def decode(<<right>>, left, right, {min, max}), do: max

  def decode(<<left, rest::binary()>>, left, right, {min, max}),
    do: decode(rest, left, right, {min, max - div(max - min, 2)})

  def decode(<<right, rest::binary()>>, left, right, {min, max}),
    do: decode(rest, left, right, {min + div(max - min, 2), max})

  def input_stream(path) do
    File.stream!(path)
    |> Stream.map(&parse/1)
  end

  defp parse(line), do: String.trim(line)
end

input = Aoc2020.Day05.input_stream("input.txt")

Aoc2020.Day05.part1(input)
|> IO.inspect(label: "part1")
