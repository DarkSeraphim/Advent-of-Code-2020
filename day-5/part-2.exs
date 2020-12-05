defmodule Day5_2 do
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

  def find_empty_with_neighbours(filled) do
    0..1024 # There's 10 bits of seats, so 1024 is the max seat id
    |> Enum.filter(&(not MapSet.member?(filled, &1)))
    |> Enum.filter(&(MapSet.member?(filled, &1 + 1)))
    |> Enum.filter(&(MapSet.member?(filled, &1 - 1)))
    |> Enum.map(&Integer.to_string/1)
  end

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&map_to_binary/1)
    |> MapSet.new()
    |> find_empty_with_neighbours()
    |> IO.puts()
  end
end

Day5_2.solve()
