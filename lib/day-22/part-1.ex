defmodule Day22_1 do
  import Common

  def parse_player(cards) do
    String.split(cards, "\n")
    |> Enum.drop(1)
    |> Enum.map(&int/1)
  end

  def play([[], player2]), do: player2

  def play([player1, []]), do: player1

  def play([[p1hand | p1deck], [p2hand | p2deck]]) do
    cond do
      p1hand > p2hand -> play([p1deck ++ [p1hand, p2hand], p2deck])
      p1hand < p2hand -> play([p1deck, p2deck ++ [p2hand, p1hand]])
    end
  end

  def solve() do
    read_lines("\n\n")
    |> Enum.map(&parse_player/1)
    |> play()
    |> Kernel.++([0])
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn({a, b}) -> a * b end)
    |> Enum.sum()
    |> to_string()
    |> IO.puts()
  end
end
