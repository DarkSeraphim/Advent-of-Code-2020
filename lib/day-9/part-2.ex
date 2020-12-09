defmodule Day9_2 do 
  def search(min, max, sum, enum, target) do
    cond do
      sum < target -> search(min, max + 1, sum + Enum.at(enum, max), enum, target)
      sum == target -> {min, max}
      sum > target -> search(min + 1, max, sum - Enum.at(enum, min), enum, target)
    end
  end
  
  def find_subset({enum, target}) do
    {enum, search(0, 0, 0, enum, target)}
  end

  def compute_solution({enum, {min, max}}) do
    enum
    |> Enum.drop(min)
    |> Enum.take(max - min)
    |> (&(Enum.min(&1) + Enum.max(&1))).()
  end
  
  def solve() do
    Day9_1.find_first_invalid(25)
    |> find_subset()
    |> compute_solution()
    |> to_string()
    |> IO.puts()
  end
end
