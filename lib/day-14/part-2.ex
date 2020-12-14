defmodule Day14_2 do
  import Common
  use Bitwise, only_operators: true

  @x ~r/X/
  @mem_set ~r/mem\[(\d+)\] = (\d+)/

  def instantiate_set(set, i) do
    Enum.with_index(set)
    |> Enum.filter(fn({_, idx}) -> ((1 <<< idx) &&& i) != 0 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&(1 <<< &1))
    |> Enum.reduce(0, &Bitwise.|||/2)
  end

  def powerset(set) do
    for i <- 0..(1 <<< Enum.count(set)), do: instantiate_set(set, i)
  end

  def extract_x_powerset(flag) do
    Regex.scan(@x, flag, return: :index)
    |> Enum.map(&(case &1 do
      [{idx, _}] -> String.length(flag) - idx - 1 
    end))
    |> powerset()
  end

  def parse_line(<<"mask = ", flag::binary>>) do
    {:mask, {
      int(Regex.replace(@x, flag, "0"), 2), # OR will work on bits 0 and 1 in the mask
      extract_x_powerset(flag)
    }}
  end

  def parse_line(mem_line) do
    [_, addr, value] = Regex.run(@mem_set, mem_line)
    {:set, {int(addr), int(value)}}
  end

  def run({:mask, mask}, {memory, _}), do: {memory, mask}
  def run({:set, {addr, value}}, {memory, {known, floats} = mask}) do
    memory = Enum.reduce(floats, memory, &(Map.put(&2, (addr ||| known) ^^^ &1, value)))
    {memory, mask}
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
