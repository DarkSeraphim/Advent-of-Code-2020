defmodule Day21_1 do
  import Common
  
  def parse_line(s) do
    [ingredients, allergens] = String.split(s, ["(", ")"], trim: true)
    i = String.split(ingredients, " ", trim: true) |> MapSet.new()
    # First is "contains
    a = String.split(allergens, [", ", " "]) |> Enum.drop(1) |> MapSet.new()
    {i, a}
  end

  def x(allergen, allinfo) do
    allinfo 
    |> Enum.filter(&(MapSet.member?(elem(&1, 1), allergen)))
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(&MapSet.intersection/2)
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
    |> Enum.reduce(&MapSet.union/2)
    #IO.inspect(ingredients_with_allergens)
    left = MapSet.difference(all_ingredients, ingredients_with_allergens)
    #IO.inspect(left)
    ia 
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&MapSet.intersection(&1, left))
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
    |> to_string()
    |> IO.puts()
  end
end
