defmodule Aoc2020.Day08 do
  def part1(program) do
    program
    |> Enum.into(%{})
    |> run_program()
  end

  def part2(input) do
    program =
      input
      |> Enum.into(%{})

    fix_program(program)
  end

  defp fix_program(program), do: fix_program(program, 0, program)

  defp fix_program(modified, address, original) do
    case run_program(modified) do
      {:crash, _} ->
        case original[address] do
          {:acc, _} ->
            fix_program(original, address + 1, original)

          instruction ->
            fix_program(Map.put(original, address, swap(instruction)), address + 1, original)
        end

      code ->
        code
    end
  end

  defp swap({:jmp, value}), do: {:nop, value}
  defp swap({:nop, value}), do: {:jmp, value}

  def run_program(program) do
    run_program(program, {0, 0, MapSet.new()})
  end

  defp run_program(program, {pc, acc, seen}) do
    if MapSet.member?(seen, pc) do
      {:crash, acc}
    else
      case program[pc] do
        nil ->
          {:exit, acc}

        instruction ->
          {next_pc, acc} = execute({pc, acc}, instruction)
          run_program(program, {next_pc, acc, MapSet.put(seen, pc)})
      end
    end
  end

  def execute({pc, acc}, {:nop, _}), do: {pc + 1, acc}
  def execute({pc, acc}, {:acc, value}), do: {pc + 1, acc + value}
  def execute({pc, acc}, {:jmp, offset}), do: {pc + offset, acc}

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

    {index, {String.to_existing_atom(instruction), String.to_integer(number)}}
  end
end

input = Aoc2020.Day08.input_stream("input.txt")

Aoc2020.Day08.part1(input)
|> IO.inspect(label: "part1")

Aoc2020.Day08.part2(input)
|> IO.inspect(label: "part2")
