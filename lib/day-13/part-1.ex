defmodule Day13_1 do

  def not_x("x"), do: false
  def not_x(_y), do: true

  def compute(min_departure, loop) do
    [loop - rem(min_departure, loop), loop]
  end

  def solve() do
    min_departure = Common.read_int()
    Common.read_line()
    |> String.split(",")
    |> Enum.filter(&not_x/1)
    |> Enum.map(&Common.int/1)
    |> Enum.map(&(compute(min_departure, &1)))
    |> Enum.min()
    |> Enum.reduce(&Kernel.*/2)
    |> IO.puts()
  end
end
