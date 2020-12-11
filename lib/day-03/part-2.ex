defmodule Day3_2 do
  defp check_tree({column, row}, trees) do
    if row < Enum.count(trees) do
      treeRow = Enum.at(trees, row)
      Enum.at(treeRow, Kernel.rem(column, Enum.count(treeRow)))
    else
      '.'
    end
  end

  defp count_trees(trees, {step_col, step_row}) do
    0..Enum.count(trees)
    |> Enum.map(&Kernel.*(&1, step_col))
    |> Enum.zip(
      0..ceil(Enum.count(trees) / step_row)
      |> Enum.map(&Kernel.*(&1, step_row))
    )
    |> Enum.map(&(check_tree(&1, trees)))
    |> Enum.filter(&(&1 == "#"))
    |> Enum.count()
  end

  def solve_for_set(trees) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(&(count_trees(trees, &1)))
    |> Enum.reduce(&(&1 * &2))
  end

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&(String.split(&1, "", trim: true)))
    |> solve_for_set()
    |> IO.puts()
  end
end
