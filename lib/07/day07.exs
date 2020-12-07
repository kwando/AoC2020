defmodule Aoc2020.Day07 do
  def part1(input) do
    rules =
      input
      |> Enum.into(%{})

    for {color, specs} <- rules, color != "shiny gold", reduce: [] do
      list ->
        if find(rules, specs, "shiny gold") do
          [color | list]
        else
          list
        end
    end
    |> Enum.count()
  end

  def part2(input) do
    rules =
      input
      |> Enum.into(%{})

    count_bags(rules, "shiny gold") - 1
  end

  def find(rules, [], _), do: false
  def find(rules, [{_, color} | rest], color), do: true

  def find(rules, [{_, child_color} | rest], color),
    do: find(rules, rest, color) || find(rules, Map.get(rules, child_color, []), color)

  def count_bags(rules, color) do
    specs = Map.get(rules, color, [])

    for {quantity, color} <- specs, reduce: 1 do
      sum ->
        sum + quantity * count_bags(rules, color)
    end
  end

  def input_stream(path) do
    File.stream!(path)
    |> Stream.map(&parse/1)
  end

  def parse(line) do
    line
    |> String.replace(["bags", "contain", "bag"], "")
    |> String.replace(~r/\s+|\./, " ")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn part -> String.trim(part) |> String.split(" ") end)
    |> create_rule()
  end

  def create_rule([[mod, color | rule] | rules]) do
    {"#{mod} #{color}", parse_spec([rule | rules])}
  end

  defp parse_spec([["no", "other"]]), do: []
  defp parse_spec([]), do: []

  defp parse_spec([[quantity, mod, color] | rest]) do
    [{String.to_integer(quantity), "#{mod} #{color}"} | parse_spec(rest)]
  end
end

input = Aoc2020.Day07.input_stream("input.txt")

Aoc2020.Day07.part1(input)
|> IO.inspect(label: "part1")

Aoc2020.Day07.part2(input)
|> IO.inspect(label: "part2")
