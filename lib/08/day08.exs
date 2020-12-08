defmodule Aoc2020.Day08 do
  def part1(program) do
    program
    |> Enum.into(%{})
    |> run_program()
  end

  def run_program(program) do
    run_program(program, {0, 0, MapSet.new()})
  end

  defp run_program(program, {pc, acc, seen}) do
    if MapSet.member?(seen, pc) do
      acc
    else
      seen = MapSet.put(seen, pc)
      {pc, acc} = execute({pc, acc}, program[pc])

      run_program(program, {pc, acc, seen})
    end
  end

  def execute({pc, acc}, {"nop", _}), do: {pc + 1, acc}
  def execute({pc, acc}, {"acc", value}), do: {pc + 1, acc + value}
  def execute({pc, acc}, {"jmp", offset}), do: {pc + offset, acc}

  def input_stream(path) do
    File.stream!(path)
    |> Stream.with_index()
    |> Stream.map(&parse/1)
  end

  def parse({line, index}) do
    [instruction, number] =
      line
      |> String.trim()
      |> String.split(" ", parts: 2)

    {index, {instruction, String.to_integer(number)}}
  end
end

input = Aoc2020.Day08.input_stream("input.txt")

Aoc2020.Day08.part1(input)
|> IO.inspect(label: "part1")
