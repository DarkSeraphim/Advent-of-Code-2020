defmodule Day5_1 do
  @bit_values Enum.reverse(Enum.map(0..9, &(Bitwise.bsl(1, &1))))

  def map_to_binary(s) do 
    s
    |> String.codepoints()
    |> Enum.map(&map_char_to_binary/1)
    |> Enum.zip(@bit_values)
    |> Enum.map(fn ({left, right}) -> left * right end)
    |> Enum.sum()
  end

  def map_char_to_binary("F"), do: 0
  def map_char_to_binary("B"), do: 1
  def map_char_to_binary("L"), do: 0
  def map_char_to_binary("R"), do: 1 

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&map_to_binary/1)
    |> Enum.max()
    |> IO.puts()
  end
end

Day5_1.solve()
