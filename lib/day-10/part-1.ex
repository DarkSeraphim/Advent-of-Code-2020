defmodule Day10_1 do

  def count_jolt(1, {ones, threes}), do: {ones + 1, threes}
  def count_jolt(2, jolts), do: jolts
  def count_jolt(3, {ones, threes}), do: {ones, threes + 1}

  def sum_jolts([], _num), do: {0, 1}
  def sum_jolts([next | rest], num), do:  count_jolt(next - num, sum_jolts(rest, next))

  def solve() do
    Common.read_lines()
    |> Enum.map(&Common.int/1)
    |> Enum.sort()
    |> sum_jolts(0)
    |> (&(elem(&1, 0) * elem(&1, 1))).()
    |> to_string()
    |> IO.puts()
  end
end
