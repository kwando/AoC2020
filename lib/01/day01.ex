defmodule Aoc2020.Day01 do
  def part1() do
    path = "lib/01/input.txt"

    numbers = read_numbers(path)

    {a, b} = find_sum(numbers, 2020)

    IO.inspect(a: a, b: b, sum: a + b, product: a * b)
  end

  def part2() do
    numbers = read_numbers("lib/01/input.txt")

    sum = 2020

    Enum.find(numbers, fn number ->
      diff = sum - number
      find_sum(numbers, diff)
    end)
    |> case do
      nil ->
        nil

      a ->
        {b, c} = find_sum(numbers, sum - a)
        IO.inspect(a: a, b: b, c: c, sum: a + b + c, product: a * b * c)
    end
  end

  def find_sum(numbers, sum) do
    existing_numers = numbers

    Enum.find(numbers, fn number ->
      diff = sum - number

      MapSet.member?(existing_numers, diff)
    end)
    |> case do
      nil -> nil
      number -> {number, sum - number}
    end
  end

  defp read_numbers(path) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new()
  end
end
