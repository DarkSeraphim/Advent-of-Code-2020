defmodule Day1_1 do

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&Kernel.elem(Integer.parse(&1, 10), 0))
    |> Enum.reduce_while(%{}, fn(num, req) ->
        if Map.has_key?(req, num) do
          {:halt, Map.get(req, num) * num}
        else
          {:cont, Map.put(req, 2020 - num, num)}
        end
      end)
    |> IO.puts
  end
end
