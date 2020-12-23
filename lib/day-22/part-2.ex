defmodule Day22_2 do
  import Common

  def parse_player(cards) do
    String.split(cards, "\n")
    |> Enum.drop(1)
    |> Enum.map(&int/1)
  end

  def play([[], player2], _), do: {:two, player2}
  def play([player1, []], _), do: {:one, player1}
  def play([[p1hand | p1deck] = player1, [p2hand | p2deck]] = situation, seen) do
    if MapSet.member?(seen, situation) do
      {:one, player1}
    else
      winner = if p1hand <= Enum.count(p1deck) and p2hand <= Enum.count(p2deck) do
        #IO.inspect("recurse!")
        case play([Enum.take(p1deck, p1hand), Enum.take(p2deck, p2hand)], MapSet.new()) do
          {:two, _} -> :two
          {:one, _} -> :one
        end
      else
        cond do
          p1hand > p2hand -> :one
          p1hand < p2hand -> :two
        end
      end

      seen = MapSet.put(seen, situation)
      case winner do
        :one -> play([p1deck ++ [p1hand, p2hand], p2deck], seen)
        :two -> play([p1deck, p2deck ++ [p2hand, p1hand]], seen)
      end
    end
  end

  def solve() do
    read_lines("\n\n")
    |> Enum.map(&parse_player/1)
    |> play(MapSet.new())
    |> elem(1)
    |> Kernel.++([0])
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn({a, b}) -> a * b end)
    |> Enum.sum()
    |> to_string()
    |> IO.puts()
  end
end
