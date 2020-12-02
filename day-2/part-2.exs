policy = ~r/(?<first>\d+)-(?<second>\d+) (?<char>\S): (?<password>\S+)/

validate_password = fn(match) ->
  {first, _bin} = Integer.parse(Map.get(match, "first"))
  {second, _bin} = Integer.parse(Map.get(match, "second"))
  char = Map.get(match, "char")
  password = Map.get(match, "password")
  a = String.at(password, first - 1) == char
  b = String.at(password, second - 1) == char
  cond do
    a and not b -> 1
    b and not a -> 1
    true -> 0
  end
end

IO.read(:stdio, :all)
|> String.trim_trailing()
|> String.split("\n")
|> Enum.map(&(Regex.named_captures(policy, &1)))
|> Enum.map(&(validate_password.(&1)))
|> Enum.sum()
|> IO.puts()
