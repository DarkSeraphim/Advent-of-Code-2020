Code.require_file("lib.exs")

defmodule Day8_1 do
  def execute({"nop", _}, ip, acc), do: {ip + 1, acc}
  def execute({"acc", value}, ip, acc), do: {ip + 1, acc + value}
  def execute({"jmp", value}, ip, acc), do: {ip + value, acc}

  def start(code), do: next({0, 0}, code, MapSet.new())

  def next({ip, acc}, code, visited) do
    case MapSet.member?(visited, ip) do
      true -> acc
      false -> execute(Enum.at(code, ip), ip, acc) 
               |> next(code, MapSet.put(visited, ip))
    end
  end

  def parse_line(<<instruction::binary-size(3), " ", num::binary>>) do
    {instruction, Common.int(num)}
  end

  def solve() do
    Common.read_lines()
    |> Enum.map(&parse_line/1)
    |> start
    |> to_string()
    |> IO.puts()
  end
end

Day8_1.solve()
