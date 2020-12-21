defmodule Day16_2 do
  import Common

  @rule ~r/(.*): (\d+)-(\d+) or (\d+)-(\d+)/
  
  def parse_rules([]), do: []
  def parse_rules([rule | lines]) do
    [_, name, a, b, c, d] = Regex.run(@rule, rule)
    [{name, [int(a)..int(b), int(c)..int(d)]} | parse_rules(lines)]
  end

  def parse_ticket(ticket) do
    String.split(ticket, ",")
    |> Enum.map(&int/1)
  end

  def check_rule(num, {_name, [rangeA, rangeB]}) do
    num in rangeA or num in rangeB
  end

  def is_field_invalid(num, rules) do
    not Enum.any?(rules, &check_rule(num, &1))
  end

  def is_invalid(ticket, rules) do
    not (Enum.any?(ticket, &is_field_invalid(&1, rules)))
  end 

  def match_dataset({rule, _}, dataset) do
    Enum.all?(dataset, &check_rule(&1, rule)) 
  end

  def find_matches(dataset, rules) do
    Enum.with_index(rules)
    |> Enum.filter(&match_dataset(&1, dataset))
    |> Enum.map(&elem(&1, 1))
  end

  def solve_rule_assignment([], _seen), do: []
  def solve_rule_assignment([{list, idx} | remainder], seen) do
    [unseen] = Enum.filter(list, &(not MapSet.member?(seen, &1)))
    [{idx, unseen} | solve_rule_assignment(remainder, MapSet.put(seen, unseen))]
  end

  def rule_starts_with({_, {name, _}}), do: String.starts_with?(name, "departure")

  def solve() do
    [rules, your_ticket, nearby_tickets] = read_lines("\n\n")
    rules = String.split(rules, "\n") |> parse_rules()
    rules_mapping = String.split(nearby_tickets, "\n")
    |> Enum.drop(1)
    |> Enum.map(&parse_ticket/1)
    |> Enum.filter(&is_invalid(&1, rules))
    |> transpose()
    |> Enum.map(&find_matches(&1, rules))
    |> Enum.with_index()
    |> Enum.sort_by(&(Enum.count(elem(&1, 0))))
    |> solve_rule_assignment(MapSet.new())
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&Enum.at(rules, &1))
   
    String.split(your_ticket, "\n")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(&int/1)
    |> Enum.zip(rules_mapping)
    |> Enum.filter(&rule_starts_with/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(1, &Kernel.*/2)
    |> to_string()
    |> IO.puts()
  end
end
