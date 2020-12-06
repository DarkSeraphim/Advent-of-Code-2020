defmodule Day6_1 do

  @spec parse_group(String.t()) :: MapSet.t(String.t())
  def parse_member(member) do
    member
    |> String.codepoints()
    |> MapSet.new()
  end

  @spec parse_group(String.t()) :: integer
  def parse_group(group) do
    group
    |> String.split("\n")
    |> Enum.map(&parse_member/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.count()
  end

  @type solve() :: none()
  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n\n") # split groups
    |> Enum.map(&parse_group/1)
    |> Enum.sum()
    |> to_string()
    |> IO.puts()
  end

end

Day6_1.solve()
