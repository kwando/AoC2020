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
    sequence = [computer_joltage | numbers]

    graph = build_graph(sequence)
    rev_seq = Enum.reverse(sequence)

    for number <- Enum.drop(rev_seq, 0), reduce: %{} do
      cache ->
        count = count_paths(graph, number, 0, 0, cache)

        cache
        |> Map.put(number, count)
    end
    |> Map.get(computer_joltage)
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

  def count_paths(_, to, to, sum, _), do: sum + 1
  def count_paths(_, from, to, sum, _) when from < to, do: sum

  def count_paths(graph, from, to, sum, cache) do
    # IO.inspect(from: from, to: to)
    # Process.sleep(500)
    for node <- graph[from], reduce: sum do
      sum ->
        case Map.fetch(cache, node) do
          {:ok, value} -> sum + value
          :error -> count_paths(graph, node, to, sum, cache)
        end
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
