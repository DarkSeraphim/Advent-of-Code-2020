defmodule Common do
  def read_line() do
    IO.read(:stdio, :line) |> String.trim_trailing()
  end

  def read_lines(delimiter \\ "\n") do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split(delimiter)
  end

  def read_int() do
    read_line() |> int()
  end

  def int(s, base \\ 10), do: String.to_integer(s, base)

  defp map_char(mapping, char), do: Map.get(mapping, char, char)

  def inspect_grid_row(row, map, cols, mapping) do
    Enum.map(0..(cols-1), fn(col) -> map_char(mapping, Map.get(map, {col, row}, ".")) end)
    |> Enum.join("")
  end

  def inspect_grid(map, cols \\ 10, rows \\ 10, mapping \\ %{}) do
    Enum.map(0..(rows-1), (&(inspect_grid_row(&1, map, cols, mapping))))
    |> Enum.join("\n")
  end

  def transpose([[] | _]), do: []
  def transpose(matrix) do
    [Enum.map(matrix, &hd/1) | transpose(Enum.map(matrix, &tl/1))]
  end
end
