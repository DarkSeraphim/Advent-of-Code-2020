defmodule Day15_2 do
  import Common

  def find_next(last, _pos_cache, turn, turn) do
    #IO.inspect(seq, limit: :infinity)
    last
  end

  def find_next(last, pos_cache, turn, goal) do
    #IO.inspect(turn)
    target = last
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
    find_next(next, pos_cache, turn + 1, goal)
  end

  def list_to_idx_cache(list) do
    Enum.with_index(list)
    |> Enum.map(fn ({value, idx}) -> {value, [idx]} end)
    |> Map.new()
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
