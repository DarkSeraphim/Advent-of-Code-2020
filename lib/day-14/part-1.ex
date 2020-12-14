defmodule Day14_1 do
  import Common
  use Bitwise, only_operators: true

  @x ~r/X/
  @mem_set ~r/mem\[(\d+)\] = (\d+)/

  def parse_line(<<"mask = ", flag::binary>>) do
    {:mask, {
      int(Regex.replace(@x, flag, "0"), 2),
      int(Regex.replace(@x, flag, "1"), 2)
    }}
  end

  def parse_line(mem_line) do
    [_, addr, value] = Regex.run(@mem_set, mem_line)
    {:set, {int(addr), int(value)}}
  end

  def run({:mask, mask}, {memory, _}), do: {memory, mask}
  def run({:set, {addr, value}}, {memory, {ones, zeroes} = mask}) do
    {Map.put(memory, addr, (value ||| ones) &&& zeroes), mask}
  end

  def solve() do
    read_lines()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({%{}, {0, -1}}, &run/2)
    |> elem(0)
    |> Map.values()
    |> Enum.sum()
    |> to_string()
    |> IO.puts()
  end
end
