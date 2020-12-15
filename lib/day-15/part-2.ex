defmodule Day15_2 do
  import Common

  def find_next(last, _pos_cache, turn, turn) do
    last
  end

  def find_next(last, pos_cache, turn, goal) do
    target = last
    old_indices = :ets.lookup(pos_cache, target) 
    next = (case old_indices do
      [{^target, [_x]}] -> 0
      [{^target, [x, y]}] -> y - x
    end)

    pair = case :ets.lookup(pos_cache, next) do     
      [] -> [turn]
      [{^next, [x]}] -> [x, turn]
      [{^next, [_x, y]}] -> [y, turn]
    end
    
    :ets.insert(pos_cache, {next, pair})
    find_next(next, pos_cache, turn + 1, goal)
  end

  def list_to_idx_cache(list) do
    Enum.with_index(list)
    |> Enum.map(fn ({value, idx}) -> {value, [idx]} end)
    |> Enum.reduce(:ets.new(:seen, [:set]), fn(p, a) -> 
      :ets.insert(a, p)
      a 
    end)
  end

  def start_game(seq), do: find_next(List.last(seq), list_to_idx_cache(seq), Enum.count(seq), 30000000)

  def solve() do
    read_line()
    |> String.split(",")
    |> Enum.map(&int/1)
    |> start_game()
    |> to_string()
    |> IO.puts()
  end
end
