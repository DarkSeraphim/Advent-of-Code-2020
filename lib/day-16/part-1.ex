defmodule Day16_1 do
  import Common

  @rule ~r/(.*): (\d+)-(\d+) or (\d+)-(\d+)/
  
  def parse_rules([]), do: []
  def parse_rules([rule | lines]) do
    [_, name, a, b, c, d] = Regex.run(@rule, rule)
    [{name, [int(a)..int(b), int(c)..int(d)]} | parse_rules(lines)]
  end

  def check_rule({_name, [rangeA, rangeB]}, num) do
    num in rangeA or num in rangeB
  end

  def is_invalid(num, rules) do
    not Enum.any?(rules, &check_rule(&1, num))
  end

  def get_invalid(ticket, rules) do
    String.split(ticket, ",")
    |> Enum.map(&int/1)
    |> Enum.filter(&is_invalid(&1, rules))
  end

  def solve() do
    [rules, _your_ticket, nearby_tickets] = read_lines("\n\n")
    rules = String.split(rules, "\n") |> parse_rules()
    String.split(nearby_tickets, "\n")
    |> Enum.drop(1)
    |> Enum.flat_map(&get_invalid(&1, rules))
    |> Enum.sum()
    |> to_string()
    |> IO.puts()

  end
end
