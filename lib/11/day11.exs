defmodule Aoc2020.Day11 do
  def part1({rows, dim}) do
    map =
      for {row, y} <- Stream.with_index(rows),
          {chair, x} <- Stream.with_index(row),
          reduce: %{} do
        map -> Map.put(map, {x, y}, chair)
      end

    chair_positions =
      Enum.reject(map, &match?({_, :floor}, &1))
      |> Enum.map(&elem(&1, 0))

    map =
      find_occupied(map, chair_positions)
      |> print_map(dim)

    Enum.count(chair_positions, fn pos -> map[pos] === :occupied end)
  end

  @offsets [
    {-1, -1},
    {-1, 0},
    {-1, 1},
    {0, -1},
    {0, 1},
    {1, -1},
    {1, 0},
    {1, 1}
  ]

  def find_occupied(map, chair_positions) do
    case chairs_to_flip(map, chair_positions) do
      [] ->
        map

      flipped ->
        for pos <- flipped, reduce: map do
          map ->
            Map.put(map, pos, flip_chair(map, pos))
        end
        |> find_occupied(chair_positions)
    end
  end

  def chairs_to_flip(map, chair_positions) do
    for pos <- chair_positions, reduce: [] do
      flipped_chairs ->
        if flip_chair?(map, pos) do
          [pos | flipped_chairs]
        else
          flipped_chairs
        end
    end
  end

  def flip_chair(map, pos) do
    case map[pos] do
      :occupied -> :empty
      :empty -> :occupied
    end
  end

  def flip_chair?(map, pos) do
    case map[pos] do
      :floor ->
        map

      :empty ->
        count_occupied(map, pos) == 0

      :occupied ->
        count_occupied(map, pos) >= 4
    end
  end

  defp count_occupied(map, pos) do
    for offset <- @offsets, reduce: 0 do
      sum ->
        case Map.get(map, translate(pos, offset), :floor) do
          :occupied -> sum + 1
          _ -> sum
        end
    end
  end

  defp translate({x1, y1}, {x2, y2}) do
    {x1 + x2, y1 + y2}
  end

  defp print_map(map, {w, h}) do
    for y <- 0..(h - 1) do
      for x <- 0..(w - 1) do
        case Map.get(map, {x, y}) do
          :empty -> ?L
          :floor -> ?.
          :occupied -> ?#
        end
      end
    end
    |> Enum.intersperse(?\n)
    |> IO.puts()

    map
  end

  def input(path) do
    lines =
      File.stream!(path)
      |> Stream.map(fn line ->
        for <<symbol <- String.trim(line)>> do
          case symbol do
            ?. -> :floor
            ?L -> :empty
            ?# -> :occupied
          end
        end
      end)
      |> Enum.to_list()

    width = Enum.count(hd(lines))
    height = Enum.count(lines)

    {lines, {width, height}}
  end
end

input = Aoc2020.Day11.input("input.txt")

Aoc2020.Day11.part1(input)
|> IO.inspect(label: "part1")
