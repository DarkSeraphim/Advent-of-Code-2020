defmodule Day3_1 do
  defp check_tree({column, treeRow}) do
    Enum.at(treeRow, Kernel.rem(column, Enum.count(treeRow)))
  end

  defp count_trees(trees) do
    0..Enum.count(trees)
    |> Enum.map(&Kernel.*(&1, 3))
    |> Enum.zip(trees)
    |> Enum.map(&check_tree/1)
    |> Enum.filter(&(&1 == "#"))
    |> Enum.count()
  end

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> count_trees()
    |> IO.puts()
  end
end
