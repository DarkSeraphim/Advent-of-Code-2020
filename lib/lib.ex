defmodule Common do
  def read_lines(delimiter \\ "\n") do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split(delimiter)
  end

  def int(s), do: String.to_integer(s)

  defp map_char(mapping, char), do: Map.get(mapping, char, char)

  def inspect_grid_row(row, map, cols, mapping) do
    Enum.map(0..(cols-1), fn(col) -> map_char(mapping, Map.get(map, {col, row}, ".")) end)
    |> Enum.join("")
  end

  def inspect_grid(map, cols \\ 10, rows \\ 10, mapping \\ %{}) do
    Enum.map(0..(rows-1), (&(inspect_grid_row(&1, map, cols, mapping))))
    |> Enum.join("\n")
  end
end
