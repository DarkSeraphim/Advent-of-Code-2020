defmodule Day4_1 do
  @required_fields MapSet.new([
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid"
  ])
 
  def validate_passport(passport) do
    passport
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&(String.split(&1,":")))
    |> Enum.map(&(Enum.at(&1, 0)))
    |> MapSet.new()
    |> MapSet.intersection(@required_fields)
    |> Enum.count()
    |> fn(a) -> a == Enum.count(@required_fields) end.()

  end

  def solve() do
    IO.read(:stdio, :all)
    |> String.split("\n\n")
    |> Enum.filter(&validate_passport/1)
    |> Enum.count()
    |> IO.puts()
  end
end
