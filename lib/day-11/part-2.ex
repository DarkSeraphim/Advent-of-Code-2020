defmodule Day11_2 do
  #use Memoize
  
  def pair_with_idx(list), do: Enum.zip(0..Enum.count(list), list)

  def split_row({y, list}) do
    list = String.graphemes(list)
    for {x, seat} <- pair_with_idx(list), do: {{x, y}, seat}
  end

  def add_delta({dx, dy}, {x, y}), do: {dx + x, dy + y}

  def trace_seat(delta, coord, map) do
    coord = add_delta(coord, delta)
    case Map.get(map, coord) do
      "." -> trace_seat(delta, coord, map)
      nil -> "L" # Map nil, out of bounds, to empty
      x   -> x 
    end
  end

  def count_filled(coords, map) do
    (for dx <- -1..1, dy <- -1..1, {dx,dy} != {0,0}, do: {dx, dy}
      |> trace_seat(coords, map)
      |> Kernel.==("#"))
    |> Enum.filter(&(&1))
    |> Enum.count()
  end

  # Do one cycle, and return new Map
  def cycle(map) do
    (for {coords, seat} <- map, do: count_filled(coords, map)
    |> (case do
      0 when seat == "L" -> {coords, "#"};
      x when seat == "#" and x >= 5 -> {coords, "L"};
      _ -> {coords, seat};
    end))
    |> Map.new()
  end 

  def game_of_life?(map) do
    new_map = cycle(map)
    if map == new_map do
      Map.values(map)
      |> Enum.frequencies()
      |> Map.get("#")
    else
      game_of_life?(new_map)
    end
  end

  def solve() do
    Common.read_lines()
    |> pair_with_idx()
    |> Enum.flat_map(&split_row/1)
    |> Map.new()
    |> game_of_life?()
    |> IO.inspect()
  end
end
