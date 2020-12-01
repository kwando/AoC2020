defmodule Aoc2020.Day01 do
  def part1() do
    path = "lib/01/input.txt"

    numbers =
      path
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    {a, b} = find_sum(numbers, 2020)

    IO.inspect(a: a, b: b, product: a * b)
  end

  def find_sum(numbers, sum) do
    existing_numers = MapSet.new(numbers)

    number =
      Enum.find(numbers, fn number ->
        diff = sum - number

        MapSet.member?(existing_numers, diff)
      end)

    {number, sum - number}
  end
end
