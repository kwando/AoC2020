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

  defp count_uniq([member | group]) do
    count_uniq(group, member)
  end

  defp count_uniq([], value), do: count_bits(value)

  defp count_uniq([member | group], value) do
    count_uniq(group, member ||| value)
  end

  defp count_common([member | rest]), do: count_common(rest, member)

  defp count_common([], value), do: count_bits(value)

  defp count_common([member | group], value) do
    count_common(group, member &&& value)
  end

  defp count_bits(number) do
    number
    |> Integer.digits(2)
    |> Enum.sum()
  end

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

input = Aoc2020.Day06.input_stream("example.txt")

Aoc2020.Day06.part1(input)
|> IO.inspect(label: "part1")

Aoc2020.Day06.part2(input)
|> IO.inspect(label: "part2")
