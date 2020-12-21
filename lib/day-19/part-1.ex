defmodule Day19_1 do
  import Common
 
  def split_numbers(s) do
    String.split(s, " ") |> Enum.map(&int/1)
  end

  def parse_rule(rule) do 
    [num, rule] = String.split(rule, ": ")

    options = case rule do
      "\"a\"" -> ["a"]
      "\"b\"" -> ["b"]
      rule -> String.split(rule, " | ")
              |> Enum.map(&split_numbers/1)
    end
    {int(num), options}
  end

  def parse_rules([]), do: []
  def parse_rules([rule | remainder]) do
    [parse_rule(rule) | parse_rules(remainder)]
  end

  def build_regex_for_rule(rules_to_match, rule_list) do
    regex = rules_to_match
    |> Enum.map(&Enum.at(rule_list, &1))
    |> Enum.map(&build_regex(&1, rule_list))
    |> Enum.join("")
    "(#{regex})"
  end

  def build_regex([opt], _rule_list) when is_binary(opt), do: opt
  def build_regex(alternatives, rule_list) do
    regex = alternatives
    |> Enum.map(&build_regex_for_rule(&1, rule_list))
    |> Enum.join("|")
    "(#{regex})"
  end

  def solve() do
    [rules, messages] = read_lines("\n\n")
    rule_list = String.split(rules, "\n") |> parse_rules()
    |> Enum.sort()
    |> Enum.map(&elem(&1, 1))
    |> Enum.to_list()

    regex = "^#{build_regex(Enum.at(rule_list, 0), rule_list)}$"
    regex = Regex.compile!(regex)
    String.split(messages, "\n")
    |> Enum.filter(&Regex.match?(regex, &1))
    |> Enum.count()
    |> to_string()
    |> IO.puts()
  end
end
