defmodule Aoc2020.Day04 do
  @required_keys ~w[
    byr iyr eyr hgt hcl ecl pid
  ]
  def part1(passports) do
    passports
    |> Enum.count(&has_keys?(&1, @required_keys))
  end

  def part2(passports) do
    required_keys = ~w[
      byr iyr eyr hgt hcl ecl pid
    ]

    passports
    |> Enum.filter(&has_keys?(&1, @required_keys))
    |> Enum.count(&valid_passport?/1)
  end

  defp valid_passport?(passport) do
    Enum.all?(passport, fn {key, value} -> valid_field?(key, value) end)
  end

  def valid_field?("byr", value), do: year_in_range(value, 1920..2002)
  def valid_field?("iyr", value), do: year_in_range(value, 2010..2020)
  def valid_field?("eyr", value), do: year_in_range(value, 2020..2030)

  def valid_field?("hgt", value) do
    case Integer.parse(value) do
      {height, "cm"} when height in 150..193 -> true
      {height, "in"} when height in 59..76 -> true
      _ -> false
    end
  end

  def valid_field?("hcl", color), do: color =~ ~r/#[0-9a-z]{6}/
  def valid_field?("ecl", color) when color in ~w(amb blu brn gry grn hzl oth), do: true
  def valid_field?("ecl", _), do: false
  def valid_field?("cid", _), do: true

  def valid_field?("pid", value),
    do: String.length(value) === 9 && match?({_, ""}, Integer.parse(value))

  defp year_in_range(year, range) when is_binary(year) do
    case Integer.parse(year) do
      {number, ""} -> number in range
      _ -> false
    end
  end

  defp has_keys?(passport, required_keys) do
    missing_Keys = required_keys -- Map.keys(passport)

    case missing_Keys do
      [] -> true
      _ -> false
    end
  end

  def input_stream(path) do
    File.stream!(path)
    |> Stream.chunk_while(
      [],
      fn
        "\n", parts ->
          {:cont, Enum.join(parts, " "), []}

        part, parts ->
          {:cont, [String.trim(part) | parts]}
      end,
      fn parts -> {:cont, Enum.join(parts, " "), []} end
    )
    |> Stream.map(&parse/1)
  end

  defp parse(line) do
    line
    |> String.trim()
    |> String.split(" ")
    |> Enum.into(%{}, fn kv ->
      [k, v] = String.split(kv, ":", parts: 2)
      {k, v}
    end)
  end
end

input = Aoc2020.Day04.input_stream("input.txt")

Aoc2020.Day04.part1(input)
|> IO.inspect(label: "part1")

Aoc2020.Day04.part2(input)
|> IO.inspect(label: "part2")
