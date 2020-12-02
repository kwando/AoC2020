defmodule Aoc2020.Day02 do
  def part1() do
    input_stream("lib/02/input.txt")
    |> Enum.count(fn {policy, password} -> valid_password?(password, policy) end)
    |> IO.inspect(label: "part1")
  end

  def part2() do
    input_stream("lib/02/input.txt")
    |> Enum.count(fn {policy, password} ->
      valid_password2?(password, policy)
    end)
    |> IO.inspect(label: "part2")
  end

  defp input_stream(path) do
    File.stream!(path)
    |> Stream.map(fn line ->
      [policy, password] = String.split(line, ":")
      {parse_policy(policy), String.trim(password)}
    end)
  end

  def parse_policy(policy) do
    [spec, char] = String.split(policy, " ", parts: 2)
    [min, max] = String.split(spec, "-", parts: 2)

    {String.to_integer(min), String.to_integer(max), char}
  end

  def valid_password?(password, {min, max, char}) do
    password
    |> String.graphemes()
    |> Enum.count(fn x -> x === char end)
    |> Kernel.in(min..max)
  end

  @spec valid_password2?(binary, {integer, integer, any}) :: boolean
  def valid_password2?(password, {a, b, char}) do
    xor(String.at(password, a - 1) === char, String.at(password, b - 1) === char)
  end

  defp xor(a, b) when is_boolean(a) and is_boolean(b), do: a != b
end
