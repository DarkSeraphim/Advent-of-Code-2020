policy = ~r/(?<min>\d+)-(?<max>\d+) (?<char>\S): (?<password>\S+)/

validate_password = fn(match) ->
  {min, _bin} = Integer.parse(Map.get(match, "min"))
  {max, _bin} = Integer.parse(Map.get(match, "max"))
  Regex.compile!(Map.get(match, "char"))
  |> Regex.scan(Map.get(match, "password"))
  |> Enum.count()
  |> fn
    count when min <= count and count <= max -> 1
    _count -> 0
    end.()
end

IO.read(:stdio, :all)
|> String.trim_trailing()
|> String.split("\n")
|> Enum.map(&(Regex.named_captures(policy, &1)))
|> Enum.map(&(validate_password.(&1)))
|> Enum.sum()
|> IO.puts()
