defmodule Aoc2020.Day06 do
  def part1(input) do
    input
    |> Stream.map(&unique_chars/1)
    |> Enum.sum()
  end

  def unique_chars(group) do
    for member <- group, <<char <- member>>, reduce: MapSet.new() do
      set ->
        MapSet.put(set, char)
    end
    |> MapSet.size()
  end

  def input_stream(path) do
    chunk_fun = fn
      "", parts -> {:cont, parts, []}
      part, parts -> {:cont, [part | parts]}
    end

    after_fun = fn
      parts -> {:cont, parts, []}
    end

    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_while([], chunk_fun, after_fun)
  end
end

input = Aoc2020.Day06.input_stream("input.txt")

Aoc2020.Day06.part1(input)
|> IO.inspect(label: "part1")
