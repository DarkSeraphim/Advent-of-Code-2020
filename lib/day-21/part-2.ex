defmodule Day21_2 do
  import Common
  
  def parse_line(s) do
    [ingredients, allergens] = String.split(s, ["(", ")"], trim: true)
    i = String.split(ingredients, " ", trim: true) |> MapSet.new()
    # First is "contains
    a = String.split(allergens, [", ", " "]) |> Enum.drop(1) |> MapSet.new()
    {i, a}
  end

  def x(allergen, allinfo) do
    {allergen, allinfo 
    |> Enum.filter(&(MapSet.member?(elem(&1, 1), allergen)))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&MapSet.intersection/2)}
  end

  def solve() do
    ia = read_lines()
    |> Enum.map(&parse_line/1)

    all_allergens = ia
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(&MapSet.union/2)

    all_ingredients = ia
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&MapSet.union/2)

    ingredients_with_allergens = all_allergens
    |> Enum.map(&x(&1, ia))
    |> Map.new()
    IO.inspect(ingredients_with_allergens)
    
  end
end
