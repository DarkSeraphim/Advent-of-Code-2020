defmodule Day17_2 do
  import Common

  def parse_line({line, row}) do
    String.graphemes(line)
    |> Enum.with_index()
    |> Enum.filter(&Kernel.==(elem(&1, 0), "#"))
    |> Enum.map(&({elem(&1, 1), row, 0, 0}))
  end

  def run_rules({cx, cy, cz, cw} = cube, cubes) do
    active = MapSet.member?(cubes, cube)
    (for x <- -1..1, y <- -1..1, z <- -1..1, w <- -1..1, do:
      {x + cx, y + cy, z + cz, w + cw})
    |> Enum.filter(&(cube != &1))
    |> Enum.filter(&MapSet.member?(cubes, &1))
    |> Enum.count()
    |> (case do
      x when active and x in 2..3 -> [cube]
      x when not active and x == 3 -> [cube]
      _ -> []
    end) 
  end

  def check_neighbours({cx, cy, cz, cw}, cubes) do
    (for x <- -1..1, y <- -1..1, z <- -1..1, w <- -1..1, do:
      {x + cx, y + cy, z + cz, w + cw})
    |> Enum.flat_map(&run_rules(&1, cubes))
  end

  def simulate_universe(cubes, round, round), do: cubes
  def simulate_universe(cubes, round, target) do
    Enum.flat_map(cubes, &check_neighbours(&1, cubes))
    |> MapSet.new()
    |> simulate_universe(round + 1, target)
  end

  def solve() do
    read_lines()
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
    |> MapSet.new()
    |> simulate_universe(0, 6)
    |> Enum.count()
    |> to_string()
    |> IO.puts()
  end
end
