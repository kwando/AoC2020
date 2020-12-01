defmodule Aoc2020.Day01 do
  def part1() do
    path = "lib/01/input.txt"

    numbers =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()
      |> IO.inspect(label: "numbers")

    {a, b} = find_sum(numbers, 2020)
    IO.inspect(a: a, b: b, product: a * b)
  end

  def find_sum(numbers, sum) do
    Stream.zip([numbers, Enum.reverse(numbers)])
    |> Enum.find(fn {a, b} -> IO.inspect(a + b) === sum end)
  end
end
