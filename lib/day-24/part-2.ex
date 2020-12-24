defmodule Day24_2 do
  import Common

  def parse_line(""), do: []
  def parse_line("nw" <> rest), do: [:nw | parse_line(rest)]
  def parse_line("ne" <> rest), do: [:ne | parse_line(rest)]
  def parse_line("w" <> rest),  do: [:w | parse_line(rest)]
  def parse_line("e" <> rest),  do: [:e | parse_line(rest)]
  def parse_line("sw" <> rest), do: [:sw | parse_line(rest)]
  def parse_line("se" <> rest), do: [:se | parse_line(rest)]

  def reduce(map, a, b, to) do
    na = Map.get(map, a, 0)
    nb = Map.get(map, b, 0)
    nt = Map.get(map, to, 0)
    overlap = min(na, nb)
    Map.put(map, a, na - overlap)
    |> Map.put(b, nb - overlap)
    |> Map.put(to, overlap + nt)
  end

  def dedupe(a, b, map) do
    na = Map.get(map, a, 0)
    nb = Map.get(map, b, 0)
    cond do
      na == nb -> {0, ""}
      na > nb -> {a, String.duplicate("#{a}", na - nb)}
      na < nb -> {b, String.duplicate("#{b}", nb - na)}
    end
  end

  def keep_reducing(map) do
    reduced = map
    |> reduce(:se, :w, :sw)
    |> reduce(:ne, :w, :nw)
    |> reduce(:sw, :e, :se)
    |> reduce(:nw, :e, :ne)
    |> reduce(:se, :w, :sw)
    |> reduce(:ne, :w, :nw)
    |> reduce(:sw, :e, :se)
    |> reduce(:nw, :e, :ne)
    |> reduce(:nw, :sw, :w)
    |> reduce(:ne, :se, :e)
    if map != reduced do
      keep_reducing(reduced)
    else
      reduced
    end
  end

  def to_coord(s) when is_binary(s), do: parse_line(s) |> to_coord()

  # parsed string
  def to_coord([_ | _] = list) do
    freqs = Enum.frequencies(list)
    |> keep_reducing() 

    [dedupe(:ne, :sw, freqs), dedupe(:nw, :se, freqs), dedupe(:w, :e, freqs)]
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.join("")
  end

  @edges ["ne", "nw", "e", "w", "se", "sw"]
  def get_neighbours(tile) do
    [tile | (for e <- @edges, do: to_coord(tile <> e))]
  end

  def is_black(tile, tiles) do
    count = (for e <- @edges, do: to_coord(tile <> e))
    |> Enum.filter(&MapSet.member?(tiles, &1))
    |> Enum.count()

    tile_is_black = MapSet.member?(tiles, tile)

    case count do
      2 when not tile_is_black -> [tile]
      0 when tile_is_black -> []
      x when x > 2 and tile_is_black -> []
      _ when tile_is_black -> [tile]
      _ -> []
    end
  end

  def get_next_black_tiles(tiles) do
    tiles
    |> Enum.flat_map(&get_neighbours/1)
    |> Enum.uniq()
    |> Enum.flat_map(&is_black(&1, tiles))
    |> MapSet.new()
  end

  def play_gol(tiles, 0), do: tiles
  def play_gol(tiles, n) do 
    play_gol(get_next_black_tiles(tiles), n - 1)
  end

  def solve() do
    read_lines()
    |> Enum.map(&parse_line/1)
    |> Enum.map(&to_coord/1)
    |> Enum.frequencies()
    |> Enum.filter(&(rem(elem(&1, 1), 2) == 1))
    |> Enum.map(&elem(&1, 0))
    |> MapSet.new()
    |> play_gol(100)
    |> Enum.count()
    |> to_string()
    |> IO.puts()
  end
end
