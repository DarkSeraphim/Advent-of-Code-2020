defmodule Day23_1 do
  import Common
 
  def find_spot(current, rest) do
    {smaller, bigger} = Enum.split_with(rest, &(&1 < current))
    Enum.max(smaller, &>=/2, fn() -> nil end) || Enum.max(bigger, &>=/2, fn() -> nil end)
  end
  
  def play_round([current, a, b, c | rest]) do
    place_at = find_spot(current, rest)
    {bef, aft} = Enum.split_while(rest, &(&1 != place_at))
    aft = tl(aft) # strip place_at from ge
    bef ++ [place_at] ++ [a, b, c] ++ aft ++ [current]
  end

 
  def simulate(cups, rounds \\ 100)
  def simulate(cups, 0), do: cups
  def simulate(cups, n), do: simulate(play_round(cups), n - 1)

  def grab_number(cups) do
    {bef, aft} = Enum.split_while(cups, &(&1 != 1))
    tl(aft) ++ bef
    |> Enum.map(&to_string/1)
    |> Enum.join()
  end

  def solve() do
    read_line()
    |> String.graphemes()
    |> Enum.map(&int/1)
    |> simulate(100)
    |> grab_number()
    |> IO.puts()
  end
end
