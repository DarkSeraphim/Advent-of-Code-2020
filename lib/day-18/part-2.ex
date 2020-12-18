defmodule Day18_2 do
  import Common

  def x ~>> y do
    x * y
  end

  def change_mult(s) do
    String.replace(s, "*", "~>>")
  end

  def solve_line(s) do
    Code.eval_string("import Day18_2; import Kernel, except: [~>>: 2]; " <> s)
    |> elem(0)
  end

  def solve() do
    read_lines()
    |> Enum.map(&change_mult/1)
    |> Enum.map(&solve_line/1)
    |> Enum.sum()
    |> to_string()
    |> IO.puts()
  end
end
