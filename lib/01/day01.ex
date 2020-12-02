defmodule Aoc2020.Day01 do
  def part1() do
    path = "lib/01/input.txt"

    numbers = read_numbers(path)

    {a, b} = find_sum(numbers, 2020)

    IO.inspect(a: a, b: b, sum: a + b, product: a * b)
  end

  def part2(), do: part2(read_numbers("lib/01/input.txt"))

  def part2(numbers) do
    sum = 2020

    a =
      numbers
      |> Enum.find(&find_sum(numbers, sum - &1))

    {b, c} = find_sum(numbers, sum - a)

    # IO.inspect(a: a, b: b, c: c, sum: a + b + c, product: a * b * c)
  end

  @spec find_sum(MapSet.t(), number) :: nil | {number, number}
  def find_sum(numbers, sum) do
    numbers
    |> Enum.find(&MapSet.member?(numbers, sum - &1))
    |> case do
      nil -> nil
      number -> {number, sum - number}
    end
  end

  def read_numbers(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new()
  end
end
