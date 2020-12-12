defmodule Day12_2 do
  def parse_instruction(<<action::binary-size(1), number::binary>>) do
    {String.to_atom(action), Common.int(number)}
  end

  def rotate_left(0, waypoint), do: waypoint
  def rotate_left(x, %{e: e, n: n}), do: rotate_left(x - 90, %{e: n, n: -e})

  def step({:N, value}, {ship, %{e: we, n: wn}}), do: {ship, %{e: we, n: wn + value}}
  def step({:S, value}, {ship, %{e: we, n: wn}}), do: {ship, %{e: we, n: wn - value}}
  def step({:E, value}, {ship, %{e: we, n: wn}}), do: {ship, %{e: we + value, n: wn}}
  def step({:W, value}, {ship, %{e: we, n: wn}}), do: {ship, %{e: we - value, n: wn}}
  
  def step({:R, v}, {ship, %{e: we, n: wn}}) do
    %{e: de, n: dn} = rotate_left(v, %{e: we - ship.e, n: wn - ship.n})
    {ship, %{e: ship.e + de, n: ship.n + dn}}
  end

  def step({:L, value}, state), do: step({:R, 360 - value}, state)
  def step({:F, value}, {%{e: se, n: sn}, %{e: we, n: wn}}) do
    de = (we - se) * value
    dn = (wn - sn) * value
    {%{e: se + de, n: sn + dn}, %{e: we + de, n: wn + dn}}
  end

  def solve() do
    Common.read_lines()
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce({%{e: 0, n: 0}, %{e: 10, n: 1}}, &step/2)
    |> elem(0)
    |> Map.values()
    |> Enum.map(&Kernel.abs/1)
    |> Enum.reduce(&Kernel.+/2)
    |> to_string()
    |> IO.puts()
  end
end
