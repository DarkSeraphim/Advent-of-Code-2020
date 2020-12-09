defmodule Day8_2 do
  def execute({"nop", _value}, ip, acc), do: {ip + 1, acc}
  def execute({"acc", value}, ip, acc), do: {ip + 1, acc + value}
  def execute({"jmp", value}, ip, acc), do: {ip + value, acc}

  def swap(list, idx) do
    Enum.at(list, idx)
    |> case do
      {"jmp", value} -> {"nop", value}
      {"nop", value} -> {"jmp", value}
      x -> x
    end
    |> fn(e) -> List.replace_at(list, idx, e) end.()
  end

  def next(code, ip, acc, visited, swapped) do
    if ip >= Enum.count(code) do
      {:ok, acc}
    else
      {ip, acc} = execute(Enum.at(code, ip), ip, acc)
      if MapSet.member?(visited, ip) do
        {:loop, -1}
      else
        # try the next step
        {loop, value} = next(code, ip, acc, MapSet.put(visited, ip), swapped)
        # The next step will always loop, try swapping if we didn't already
        # Possible optimisation: check if the operator is swappable
        if loop == :loop and not swapped do
          next(swap(code, ip), ip, acc, MapSet.put(visited, ip), true)
        else
          # Already attempted it, sad, let's try our parent :)
          {loop, value}
        end
      end
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
    |> next(0, 0, MapSet.new(), false)
    |> elem(1)
    |> to_string()
    |> IO.puts()
  end
end
