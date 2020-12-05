defmodule Aoc2020.Day05 do
  def part1(input) do
    input
    |> Stream.map(&seat_id/1)
    |> Enum.max()
  end

  def part2(input) do
    input
    |> Stream.map(&seat_id/1)
    |> Enum.sort()
    |> Enum.drop_while(&(&1 <= 7))
    |> find_gap()
  end

  def find_gap([a, b | rest]) when b - a == 2, do: a + 1
  def find_gap([a, b | rest]) when b - a == 1, do: find_gap([b | rest])

  def seat_id(spec) when is_binary(spec) do
    {rows, cols} = String.split_at(spec, 7)
    seat_id({decode(rows, ?F, ?B, {0, 127}), decode(cols, ?L, ?R, {0, 7})})
  end

  def seat_id({row, col}) do
    row * 8 + col
  end

  def decode(<<lft>>, lft, _rgt, {min, _max}), do: min
  def decode(<<rgt>>, _lft, rgt, {_min, max}), do: max

  def decode(<<lft, rest::binary()>>, lft, rgt, {min, max}),
    do: decode(rest, lft, rgt, {min, max - mid(min, max)})

  def decode(<<rgt, rest::binary()>>, lft, rgt, {min, max}),
    do: decode(rest, lft, rgt, {min + mid(min, max), max})

  defp mid(min, max), do: div(max - min, 2) + 1

  def input_stream(path) do
    File.stream!(path)
    |> Stream.map(&parse/1)
  end

  defp parse(line), do: String.trim(line)
end

357 = Aoc2020.Day05.seat_id({44, 5})
357 = Aoc2020.Day05.seat_id("FBFBBFFRLR")

567 = Aoc2020.Day05.seat_id({70, 7})
567 = Aoc2020.Day05.seat_id("BFFFBBFRRR")

119 = Aoc2020.Day05.seat_id({14, 7})
119 = Aoc2020.Day05.seat_id("FFFBBBFRRR")

820 = Aoc2020.Day05.seat_id({102, 4})
820 = Aoc2020.Day05.seat_id("BBFFBBFRLL")

input = Aoc2020.Day05.input_stream("input.txt")

Aoc2020.Day05.part1(input)
|> IO.inspect(label: "part1")

Aoc2020.Day05.part2(input)
|> IO.inspect(label: "part2")
