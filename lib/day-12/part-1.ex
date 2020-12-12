defmodule Day12_1 do
  def parse_instruction(<<action::binary-size(1), number::binary>>) do
    {String.to_atom(action), Common.int(number)}
  end

  def to_degree(:N), do: 0
  def to_degree(:W), do: 90
  def to_degree(:S), do: 180
  def to_degree(:E), do: 270
  
  def from_degree(0), do: :N
  def from_degree(90), do: :W
  def from_degree(180), do: :S
  def from_degree(270), do: :E


  def step({:N, value}, {dir, %{east: east, north: north}}), do: {dir, %{east: east, north: north + value}}
  def step({:S, value}, {dir, %{east: east, north: north}}), do: {dir, %{east: east, north: north - value}}
  def step({:E, value}, {dir, %{east: east, north: north}}), do: {dir, %{east: east + value, north: north}}
  def step({:W, value}, {dir, %{east: east, north: north}}), do: {dir, %{east: east - value, north: north}}
  def step({:L, value}, {dir, map}), do: {rem(dir + value, 360), map}
  def step({:R, value}, state), do: step({:L, 360 - value}, state)
  def step({:F, value}, {dir, map}), do: step({from_degree(dir), value}, {dir, map})

  def solve() do
    Common.read_lines()
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce({to_degree(:E), %{east: 0, north: 0}}, &step/2)
    |> elem(1)
    |> Map.values()
    |> Enum.map(&Kernel.abs/1)
    |> Enum.reduce(&Kernel.+/2)
    |> to_string()
    |> IO.puts()
  end
end
