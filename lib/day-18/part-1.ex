defmodule Day18_1 do
  import Common

  def compute(lhs, rhs, :+), do: lhs + rhs
  def compute(lhs, rhs, :*), do: lhs * rhs

  def solve_line(list, res \\ 0, op \\ :+)
  def solve_line([], res, _), do: res
  def solve_line([next | remainder], res, op) do
    case next do
      "(" -> 
        {res2, remainder} = solve_line(remainder)
        solve_line(remainder, compute(res, res2, op))
      ")" -> {res, remainder}
      "+" -> solve_line(remainder, res, :+)
      "*" -> solve_line(remainder, res, :*)
      next -> solve_line(remainder, compute(res, int(next), op))
    end
  end

  def split_it(s), do: String.graphemes(s) |> Enum.filter(&(&1 != " "))

  def solve() do
    read_lines()
    |> Enum.map(&split_it/1)
    |> Enum.map(&solve_line/1)
    |> Enum.sum()
    |> to_string()
    |> IO.puts()
  end
end
