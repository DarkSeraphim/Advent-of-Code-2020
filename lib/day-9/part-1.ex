defmodule Day9_1 do
  def if_cont_return(tuple) do
    case tuple do
      {:halt, _} -> false
      _ -> true
    end
  end

  def check_slice(start, enum, size) do
    Enum.drop(enum, start)
    |> (&(Day1_2.solve_for_n(Enum.take(&1, size), Enum.at(&1, size)))).()
    |> if_cont_return
  end

  def produce_ranges(enum, size) do
    0..(Enum.count(enum) - (size + 1))
    |> Enum.filter(&(check_slice(&1, enum, size)))
    |> (&(Enum.at(enum, Enum.at(&1, 0) + size))).()
  end

  def find_first_invalid(window) do
    Common.read_lines()
    |> Enum.map(&Common.int/1)
    |> (&({&1, produce_ranges(&1, window)})).()
  end

  def solve() do
    find_first_invalid(25)
    |> elem(1)
    |> to_string()
    |> IO.puts()
  end
end
