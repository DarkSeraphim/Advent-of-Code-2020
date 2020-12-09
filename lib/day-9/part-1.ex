defmodule Day9_1 do
  def if_not_halt_return({:halt, _}), do: false
  def if_not_halt_return(_), do: true

  def check_slice(start, enum, size) do
    Enum.drop(enum, start)
    |> Enum.take(size)
    |> Day1_2.solve_for_n(Enum.at(enum, start + size))
    |> if_not_halt_return
  end

  def produce_ranges(enum, size) do
    0..(Enum.count(enum) - (size + 1))
    |> Enum.filter(&(check_slice(&1, enum, size)))
    |> Enum.at(0)
    |> (&(Enum.at(enum, &1 + size))).()
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
