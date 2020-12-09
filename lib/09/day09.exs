defmodule Aoc2020.Day09 do
  def part1({input, preamble_size}) do
    numbers =
      input
      |> Enum.reverse()
      |> Enum.drop(1)

    test_numbers =
      input
      |> Enum.drop(preamble_size)
      |> Enum.reverse()

    for number <- test_numbers, reduce: {[], numbers} do
      {seq, numbers} ->
        {[{number, check_number(number, numbers, preamble_size - 1)} | seq],
         Enum.drop(numbers, 1)}
    end
    |> elem(0)
    |> Enum.find(&match?({_, false}, &1))
    |> elem(0)
  end

  def part2({input, _}, value) do
    numbers = Enum.to_list(input)
    find_contiguous(numbers, value)
  end

  defp find_contiguous(numbers, value) do
    case find_range(numbers, value, 0) do
      false ->
        find_contiguous(Enum.drop(numbers, 1), value)

      len ->
        {min, max} =
          numbers
          |> Enum.take(len)
          |> Enum.reduce({hd(numbers), hd(numbers)}, fn num, {min, max} ->
            {min(min, num), max(max, num)}
          end)

        min + max
    end
  end

  defp find_range([], _, _), do: false
  defp find_range(_, value, _) when value < 0, do: false
  defp find_range(_, 0, n), do: n

  defp find_range([number | numbers], value, n) do
    find_range(numbers, value - number, n + 1)
  end

  defp check_number(_, [], 0), do: false
  defp check_number(_, _, 0), do: false

  defp check_number(a, [b | rest], n) do
    !!(rest
       |> Enum.take(n)
       |> Enum.find(&(&1 + b === a)) ||
         check_number(a, rest, n - 1))
  end

  def input_stream(path, preamble) do
    {File.stream!(path)
     |> Stream.map(&parse/1), preamble}
  end

  defp parse(line) do
    line
    |> String.trim()
    |> String.to_integer()
  end
end

input = Aoc2020.Day09.input_stream("example.txt", 5)

sum =
  Aoc2020.Day09.part1(input)
  |> IO.inspect(label: "part1")

Aoc2020.Day09.part2(input, sum)
|> IO.inspect(label: "part2")
