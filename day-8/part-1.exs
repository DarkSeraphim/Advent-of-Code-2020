defmodule Day8_1 do
  def execute({"nop", _value}, ip, acc), do: {ip + 1, acc}
  def execute({"acc", value}, ip, acc), do: {ip + 1, acc + value}
  def execute({"jmp", value}, ip, acc), do: {ip + value, acc}

  def next(code, ip, acc, visited) do
    {ip, acc} = execute(Enum.at(code, ip), ip, acc)
    if MapSet.member?(visited, ip) do
      acc
    else
      next(code, ip, acc, MapSet.put(visited, ip))
    end
  end

  def parse_line(s) do
    [instruction, value] = String.split(s, " ", trim: true)
    {value, _} = Integer.parse(value)
    {instruction, value}
  end

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> next(0, 0, MapSet.new())
    |> to_string()
    |> IO.puts()
  end
end

Day8_1.solve()
