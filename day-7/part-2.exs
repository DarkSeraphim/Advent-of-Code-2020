defmodule Day7_1 do
  @spec parse_holding([String.t()]) :: {String.t(), [{String.t(), integer()}]}
  def parse_holding([bag, holding]) do
    Regex.scan(~r/(\d) (\S+ \S+) bags?/, holding)
    |> Enum.map(fn([_, num, node]) ->
      {num, _} = Integer.parse(num)
      {node, num}
    end)
    |> fn(edges) -> {bag, edges} end.() # turn it into a tuple(bag, [tuple(edge)])
  end
  
  @spec parse_bag(String.t()) :: %{optional(String.t()) => [String.t()]}
  def parse_bag(s) do
    s
    |> String.split(" bags contain ")
    |> parse_holding
  end

  def count_all(map, target_type) do
    Map.get(map, target_type)
    |> Enum.map(fn({bag_type, number}) -> 
      (number * count_all(map, bag_type)) # Count bag itself
    end)
    |> Enum.sum()
    |> Kernel.+(1)
  end

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&parse_bag/1)
    |> Map.new()
    |> count_all("shiny gold")
    |> Kernel.-(1) # Patch: exclude shiny gold bag
    |> to_string()
    |> IO.puts()
  end
end

Day7_1.solve()
