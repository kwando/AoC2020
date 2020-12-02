numbers = Aoc2020.Day01.read_numbers("lib/01/input.txt")

Benchee.run(%{
  "find_sum" => fn -> Aoc2020.Day01.find_sum(numbers, 2020) end,
  "part2" => fn -> Aoc2020.Day01.part2(numbers) end
})
