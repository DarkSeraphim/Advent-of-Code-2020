defmodule Common do
  def read_lines(delimiter \\ "\n") do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split(delimiter)
  end

  def int(s), do: String.to_integer(s)

  def inspect_grid_row(row, map, cols \\ 10) do
    Enum.map(0..(cols-1), fn(col) -> Map.get(map, {col, row}, ".") end)
    |> Enum.join("")
  end

  def inspect_grid(map, cols \\ 10, rows \\ 10) do
    IO.puts(Enum.map(0..(rows-1), (&(inspect_map_row(&1, map, cols))))
    |> Enum.join("\n"))
    map
  end
end
