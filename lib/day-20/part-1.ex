defmodule Day20_1 do
  import Common

  @tile_id_pattern ~r/Tile (\d+):/

  def parse_tile_id(tile_id) do
    case Regex.run(@tile_id_pattern, tile_id) do
      [_, id] -> int(id)
    end
  end

  def parse_tile(tile) do
    [tile_id_str | tile ] = String.split(tile, "\n")

    {parse_tile_id(tile_id_str), Enum.map(tile, &String.graphemes/1)}
  end

  def add_to_list(list, item), do: [item | list]

  def add_and_flipped(map, tile_id, side) do
    Map.update(map, side, [tile_id], &add_to_list(&1, tile_id))
    |> Map.update(String.reverse(side), [tile_id], &add_to_list(&1, tile_id))
  end

  def add_match({tile_id, tile}, matches) do
    upper = hd(tile) |> Enum.join("")
    lower = List.last(tile) |> Enum.join("")
    rotated = transpose(tile)
    left = hd(rotated) |> Enum.join("")
    right = List.last(rotated) |> Enum.join("")
    add_and_flipped(matches, tile_id, upper)
    |> add_and_flipped(tile_id, lower)
    |> add_and_flipped(tile_id, left)
    |> add_and_flipped(tile_id, right)
  end

  def has_two_matches({_side, [_a, _b]}), do: true
  def has_two_matches({_side, [_a]}), do: false

  def is_corner({_tile_id, 4}), do: true
  def is_corner(_), do: false

  def solve() do
    read_lines("\n\n")
    |> Enum.map(&parse_tile/1)
    |> Enum.reduce(%{}, &add_match/2)
    |> Map.to_list()
    |> Enum.filter(&has_two_matches/1)
    |> Enum.flat_map(&elem(&1, 1))
    |> Enum.frequencies()
    |> Enum.to_list()
    |> Enum.filter(&is_corner/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&Kernel.*/2)
    |> to_string()
    |> IO.puts()
  end
end
