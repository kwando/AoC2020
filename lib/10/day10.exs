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

  def part2(numbers) do
    numbers = Enum.sort([0 | Enum.to_list(numbers)], :desc)

    computer_joltage = hd(numbers) + 3

    graph =
      build_graph([computer_joltage | numbers])
      |> IO.inspect()

    count_paths(graph, computer_joltage, 0)
  end

  def differences([a]), do: [a]
  def differences([a | [b | _] = rest]), do: [a - b | differences(rest)]

  def build_graph(adapters) do
    for adapter <- adapters, reduce: {%{}, adapters} do
      {allowed, [_ | adapters]} ->
        {Map.put(
           allowed,
           adapter,
           Enum.take_while(adapters, fn joltage -> joltage >= adapter - 3 end)
         ), adapters}
    end
    |> elem(0)
  end

  def count_paths(_, to, to), do: 1

  def count_paths(graph, from, to) do
    for node <- graph[from], reduce: 0 do
      sum ->
        sum + count_paths(graph, node, to)
    end
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

Aoc2020.Day10.part2(input)
|> IO.inspect(label: "part2")
