defmodule Day24_1 do
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
      na > nb -> {a, "#{na - nb}#{a}"}
      na < nb -> {b, "#{nb - na}#{b}"}
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

  def dedupe(list) do
    freqs = Enum.frequencies(list)
    |> keep_reducing() 

    [dedupe(:ne, :sw, freqs), dedupe(:nw, :se, freqs), dedupe(:w, :e, freqs)]
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.join("")
  end

  def solve() do
    read_lines()
    |> Enum.map(&parse_line/1)
    |> Enum.map(&dedupe/1)
    |> Enum.frequencies()
    |> Enum.filter(&(rem(elem(&1, 1), 2) == 1))
    |> Enum.count()
    |> to_string()
    |> IO.puts()
  end
end
