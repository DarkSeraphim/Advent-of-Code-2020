defmodule Day19_2 do
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
    {int(num), {options, int(num)}}
  end

  def parse_rules([]), do: []
  def parse_rules([rule | remainder]) do
    [parse_rule(rule) | parse_rules(remainder)]
  end

  def build_regex_for_rule([rule], _rule_list, _count) when is_binary(rule), do: rule
  def build_regex_for_rule(rules_to_match, rule_list, count) do
    regex = rules_to_match
    |> Enum.map(fn (x) ->
      case x do
        x when is_binary(x) ->{[x], -1}
        x -> Map.get(rule_list, x)
      end
    end
    )
    |> Enum.map(&build_regex(&1, rule_list, count + 1))
    |> Enum.join("")
    "#{regex}"
  end

  def recurse(a, b, 1), do: "#{a}#{b}"

  def recurse(a, b, num) do
    "((#{a}){#{num}}(#{b}){#{num}})|#{recurse(a,b,num-1)}"
  end

  def patch_loop(alternative, idx, rule_list, count) do
    if idx in alternative do
      {bef, aft} = Enum.split_while(alternative, &(&1 != idx))
      aft = Enum.drop(aft, 1)

      emptyB = Enum.empty?(bef)
      emptyA = Enum.empty?(aft)

      bef = build_regex_for_rule(bef, rule_list, count + 100)
      aft = build_regex_for_rule(aft, rule_list, count + 100)

      if emptyA or emptyB do
        ["(#{bef}#{aft})+"]
      else
        [recurse(bef, aft, 5)]
      end

      #["((?<groupA#{idx}>#{bef})+(?<groupB#{idx}>#{aft})+)"]
    else
      alternative
    end
  end

  def build_regex(next, rules, count \\ 0)
  def build_regex({[opt], _idx}, _rule_list, _count) when is_binary(opt), do: opt
  def build_regex({alternatives, idx}, rule_list, count) do
    alternatives = if idx in List.flatten(alternatives) do
      Enum.map(alternatives, &patch_loop(&1, idx, rule_list, count))
    else
      alternatives
    end
    regex = alternatives
    |> Enum.map(&build_regex_for_rule(&1, rule_list, count))
    |> Enum.join("|")
    "(#{regex})"
  end

  # No groups here
  def filter_match([]), do: true
  def filter_match([[_] | remainder]), do: filter_match(remainder)
  def filter_match([[_, left, right] | remainder]) do
    IO.inspect(left, label: "left")
    IO.inspect(right, label: "right")
    filter_match(remainder)
  end

  def filter_valid(regex, left11, right11, str) do
    if not Regex.match?(regex, str) do
      #IO.inspect(Regex.scan(regex, str), label: "nop")
      false
    else
      true
      #groups = Regex.named_captures(regex, str)
      #group11A = Map.get(groups, "groupA11")
      #group11B = Map.get(groups, "groupB11")
      #if group11A == "" and group11B == "" do
      #  true
      #else
      #  IO.inspect(group11A, label: "A")
      #  IO.inspect(group11B, label: "B")
      #  num_matches = Enum.count(IO.inspect(Regex.scan(left11, group11A)))
      #  num_matches_2 = Enum.count(IO.inspect(Regex.scan(right11, group11B)))
      #  num_matches == num_matches_2
      #end
    end
  end

  def solve() do
    [rules, messages] = read_lines("\n\n")
    rule_list = String.split(rules, "\n") |> parse_rules()
    |> Map.new()

    rule_list = rule_list
      |> Map.put(8, {[[42, 8]], 8})
      |> Map.put(11, {[[42, 11, 31]], 11})

    regex = "^#{build_regex(Map.get(rule_list, 0), rule_list)}$"
    IO.puts(String.length(regex))

    left11 = Regex.compile!(build_regex(Map.get(rule_list, 42), rule_list))
    right11 = Regex.compile!(build_regex(Map.get(rule_list, 31), rule_list))

    IO.puts(regex)
    regex = Regex.compile!(regex)
    String.split(messages, "\n")
    |> Enum.filter(&filter_valid(regex, left11, right11, &1))
    |> Enum.count()
    |> to_string()
    |> IO.puts()
  end
end
