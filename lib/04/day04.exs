defmodule Aoc2020.Day04 do
  def part1(passports) do
    required_keys = ~w[
      byr iyr eyr hgt hcl ecl pid
    ]

    passports
    |> Enum.count(&has_keys?(&1, required_keys))
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
