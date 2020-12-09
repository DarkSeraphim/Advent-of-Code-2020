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

  def check_if_contains(map, bag_type, target_type) do
    Map.get(map, bag_type, [])
    |> Enum.any?(fn({edge_bag, _}) -> 
      if edge_bag == target_type do
        true
      else
        check_if_contains(map, edge_bag, target_type)
      end
    end)
  end

  def search_from_all(map, target_type) do
    Map.keys(map)
    |> Enum.filter(&(check_if_contains(map, &1, target_type)))
    |> Enum.count()
  end

  def solve() do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split("\n")
    |> Enum.map(&parse_bag/1)
    |> Map.new()
    |> search_from_all("shiny gold")
    |> to_string()
    |> IO.puts()
  end
end
