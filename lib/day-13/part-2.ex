defmodule Day13_2 do

  def not_x({"x", _}), do: false
  def not_x(_y), do: true

  def parse_part({e, idx}), do: {Common.int(e), idx}

  # we always pass num + inc, so subtract for result
  def reduce(num, inc, [_]), do: num - inc
  def reduce(num, inc, [{av, ai}, {bv, bi} | remainder]) do
    cond do
      rem(num + bi, bv) == 0 -> reduce(num + (inc * bv), inc * bv, [{bv, bi} | remainder])
      true -> reduce(num + inc, inc, [{av, ai}, {bv, bi} | remainder])
    end
  end

  def start([{av, ai} | remainder]), do: reduce(av, av, [{av, ai} | remainder])

  def solve() do
    _ = Common.read_int()
    Common.read_line()
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.filter(&not_x/1)
    |> Enum.map(&parse_part/1)
    |> start()
    |> to_string()
    |> IO.puts()
  end
end
