defmodule Day15_2 do
  import Common

  def find_next(last, _pos_cache, turn, turn), do: last
  def find_next(target, pos_cache, turn, goal) do
    next = case Map.get(pos_cache, target) do
      nil -> 0
      y -> turn - y
    end

    # The last number has officially been seen by us now
    pos_cache = Map.put(pos_cache, target, turn)
    find_next(next, pos_cache, turn + 1, goal)
  end

  def list_to_idx_cache(list) do
    Enum.with_index(list)
    # Pretend we didn't see the last number yet
    |> List.delete_at(Enum.count(list))
    |> Map.new()
  end

  def start_game(seq, rounds) do
    find_next(List.last(seq), list_to_idx_cache(seq), Enum.count(seq) - 1, rounds - 1)
  end

  def solve() do
    read_line()
    |> String.split(",")
    |> Enum.map(&int/1)
    |> start_game(30_000_000 - 1)
    |> to_string()
    |> IO.puts()
  end
end
