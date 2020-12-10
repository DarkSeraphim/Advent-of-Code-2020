defmodule Day10_2 do

  def count3([_, _, next | tail], cur, memory) when next - cur <= 3, do: count(tail, next, memory)
  def count3([_, _, next | _], cur, memory) when next - cur > 3, do: {0, memory} # I have no memory of this place
  def count3(_, _, memory), do: {0, memory}

  def count2([_, next | tail], cur, memory) when next - cur <= 2, do: count(tail, next, memory)
  def count2([_, next | _], cur, memory) when next - cur > 2, do: {0, memory} # still no memory of this place
  def count2(_, _, memory), do: {0, memory}

  def count1([next | tail], _, memory), do: count(tail, next, memory)
  def count1([], cur, memory), do: {1, Map.put(memory, cur, 1)}

  def count(enum, cur, memory) do
    if Map.has_key?(memory, cur) do
      {Map.get(memory, cur), memory}
    else
      {c1, memory} = count1(enum, cur, memory)
      {c2, memory} = count2(enum, cur, memory)
      {c3, memory} = count3(enum, cur, memory)
      result = c1 + c2 + c3
      {result, Map.put(memory, cur, result)}
    end
  end

  def solve() do
    Common.read_lines()
    |> Enum.map(&Common.int/1)
    |> Enum.sort()
    |> count(0, %{})
    |> elem(0)
    |> to_string()
    |> IO.puts()
  end
end
