defmodule Day25_1 do
  import Common

  def find_power(current, base, modulo, result, exp \\ 1) do
      current = rem(current * base, modulo)
      if current == result do
        exp
      else
        find_power(current, base, modulo, result, exp + 1)
      end
  end

  @modulo 20201227

  def powmod(res, _base, 0), do: res
  def powmod(res, base, pow), do: powmod(rem(res * base, @modulo), base, pow - 1)

  def solve() do
    [cardpk, doorpk] = read_lines()
    |> Enum.map(&int/1)
    card_loop = find_power(1, 7, @modulo, cardpk)
    powmod(1, doorpk, card_loop)
    |> rem(@modulo)
    |> IO.inspect()

  end
end
