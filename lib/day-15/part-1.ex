defmodule Day15_1 do
  import Common

  def find_next(seq, _pos_cache, turn, turn), do: List.last(seq)

  def find_next(seq, pos_cache, turn, goal) do
    target = List.last(seq)
    old_indices = Map.get(pos_cache, target) 
    next = (case old_indices do
      [_] -> 0
      [x, y] -> y - x
    end)

    pos_cache = Map.update(pos_cache, next, [turn], fn (idx) ->
      case idx do
        [x] -> [x, turn]
        [_x, y] -> [y, turn]
      end
    end)
    find_next(seq ++ [next], pos_cache, turn + 1, goal)
  end

  def list_to_idx_cache(list) do
    Enum.with_index(list)
    |> Enum.map(fn ({value, idx}) -> {value, [idx]} end)
    |> Map.new()
  end

  def start_game(seq), do: find_next(seq, list_to_idx_cache(seq), Enum.count(seq), 2020)

  def solve() do
    read_line()
    |> String.split(",")
    |> Enum.map(&int/1)
    |> start_game()
    |> to_string()
    |> IO.puts()
  end
end
