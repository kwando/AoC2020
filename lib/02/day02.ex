defmodule Aoc2020.Day02 do
  def part1() do
    File.read!("lib/02/input.txt")
    |> String.split("\n", trime: true)
    |> Enum.map(fn line ->
      [policy, password] = String.split(line, ":")
      {parse_policy(policy), password}
    end)
    |> Enum.count(fn {policy, password} -> valid_password?(password, policy) end)
    |> IO.inspect(label: "part1")
  end

  def parse_policy(policy) do
    [spec, char] = String.split(policy, " ", parts: 2)
    [min, max] = String.split(spec, "-", parts: 2)

    {String.to_integer(min), String.to_integer(max), char}
  end

  def valid_password?(password, {min, max, char}) do
    found_chars =
      password
      |> String.codepoints()
      |> Enum.count(fn x -> x === char end)

    found_chars >= min && found_chars <= max
  end
end
