defmodule Day11_2 do
  def map_tile("#"), do: :full
  def map_tile("L"), do: :empty
  def map_tile("."), do: :floor
  
  def pair_with_idx(list), do: Enum.zip(0..Enum.count(list), list)

  def split_row({y, list}) do
    list = String.graphemes(list)
    for {x, seat} <- pair_with_idx(list), do: {{x, y}, map_tile(seat)}
  end

  def add_delta({dx, dy}, {x, y}), do: {dx + x, dy + y}

  def trace_seat(delta, coord, map) do
    coord = add_delta(coord, delta)
    case Map.get(map, coord) do
      :floor -> trace_seat(delta, coord, map)
      nil -> :empty # Map nil, out of bounds, to empty
      x   -> x 
    end
  end

  def count_filled(coords, map) do
    (for dx <- -1..1, dy <- -1..1, {dx,dy} != {0,0}, do: {dx, dy}
      |> trace_seat(coords, map)
      |> Kernel.==(:full))
    |> Enum.filter(&(&1))
    |> Enum.count()
  end

  # Do one cycle, and return new Map
  def cycle(map) do
    (for {coords, seat} <- map, do: count_filled(coords, map)
    |> (case do
      0 when seat == :empty -> {coords, :full};
      x when seat == :full and x >= 5 -> {coords, :empty};
      _ -> {coords, seat};
    end))
    |> Map.new()
  end 

  def game_of_life?(map, width, height) do
    if System.get_env("ANSI") == "true" do
      :timer.sleep(500)
      IO.puts(IO.ANSI.clear())
      IO.puts(Common.inspect_grid(map, width, height, %{empty: "#{IO.ANSI.color(111)}L", full: "#{IO.ANSI.color(172)}#", floor: "#{IO.ANSI.black()} "}))
    end
    new_map = cycle(map)
    if map == new_map do
      Map.values(map)
      |> Enum.frequencies()
      |> Map.get(:full)
    else
      game_of_life?(new_map, width, height)
    end
  end

  def start_game_of_life(list) do
    {{width, height}, _} = List.last(list)
    game_of_life?(Map.new(list), width + 1, height + 1)
  end

  def solve() do
    Common.read_lines()
    |> pair_with_idx()
    |> Enum.flat_map(&split_row/1)
    |> start_game_of_life()
    |> IO.inspect()
  end
end
