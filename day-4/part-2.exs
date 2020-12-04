defmodule Day4_2 do
  @required_fields MapSet.new([
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid"
  ])

  @year_pattern ~r/^\d{4}$/
  @height_pattern ~r/^(\d{2}in|\d{3}cm)$/
  @hcl_pattern ~r/^\#[0-9a-f]{6}$/
  @ecl_values MapSet.new([
    "amb",
    "blu",
    "brn",
    "gry",
    "grn",
    "hzl",
    "oth"
  ])
  @pid_pattern ~r/^\d{9}$/

  def check_field(["byr", value]) do
    Regex.match?(@year_pattern, value) and "1920" <= value and value <= "2002"
  end

  def check_field(["iyr", value]) do
    Regex.match?(@year_pattern, value) and "2010" <= value and value <= "2020"
  end

  def check_field(["eyr", value]) do
    Regex.match?(@year_pattern, value) and "2020" <= value and value <= "2030"
  end

  def check_field(["hgt", value]) do
    if Regex.match?(@height_pattern, value) do
      cond do
        String.ends_with?(value, "cm") -> "150cm" <= value and value <= "193cm"
        String.ends_with?(value, "in") -> "59in" <= value and value <= "76in"
        true -> false # not a valid length for sure
      end
    else
      false
    end
  end

  def check_field(["hcl", value]) do
    Regex.match?(@hcl_pattern, value)
  end

  def check_field(["ecl", value]) do
    MapSet.member?(@ecl_values, value)
  end

  def check_field(["pid", value]) do
    Regex.match?(@pid_pattern, value)
  end

  def check_field([_name, _value]) do
    true # ignore unknown fields
  end

  def validate_passport(passport) do
    passport
    |> String.split([" ", "\n"], trim: true)
    |> Enum.map(&(String.split(&1,":"))) 
    |> Enum.filter(&check_field/1) # Check if attribute is valid in filter
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

Day4_2.solve()
