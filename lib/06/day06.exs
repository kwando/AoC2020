defmodule Aoc2020.Day06 do
  use Bitwise

  def part1(input) do
    input
    |> Stream.map(&count_uniq/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Stream.map(&count_common/1)
    |> Enum.sum()
  end

  defp count_uniq(group) do
    group
    |> Enum.reduce(0, fn member, acc -> acc ||| member end)
    |> count_bits()
  end

  defp count_common(group) do
    group
    |> Enum.reduce(fn member, acc -> acc &&& member end)
    |> count_bits()
  end

  def count_bits(num), do: count_bits(num, 0)
  defp count_bits(0, sum), do: sum
  defp count_bits(num, sum), do: count_bits(num &&& num - 1, sum + 1)

  def input_stream(path) do
    chunk_fun = fn
      "", parts -> {:cont, parts, []}
      part, parts -> {:cont, [encode(part) | parts]}
    end

    after_fun = fn
      parts -> {:cont, parts, []}
    end

    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_while([], chunk_fun, after_fun)
  end

  def encode(""), do: 0
  def encode(<<char, rest::binary()>>), do: 0b1 <<< (char - ?a) ||| encode(rest)
end

input = Aoc2020.Day06.input_stream("input.txt")

Aoc2020.Day06.part1(input)
|> IO.inspect(label: "part1")

Aoc2020.Day06.part2(input)
|> IO.inspect(label: "part2")
