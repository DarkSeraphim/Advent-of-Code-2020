defmodule Day23_2 do
  import Common

  def get_next(_cups, _num, 0), do: []
  def get_next(cups, num, amount) do
    next = get_next(cups, num)
    [next | get_next(cups, next, amount - 1)]
  end

  def get_next(cups, num), do: Map.get(cups, num)

  def find_after(0, picked), do: find_after(1_000_000, picked)
  def find_after(current, picked) do
    if current not in picked do
      current
    else
      find_after(current - 1, picked)
    end
  end

  def play_round(current, cups) do
    [a, _b, c] = picked = get_next(cups, current, 3)
    insert_after  = find_after(current - 1, picked)
    close = get_next(cups, insert_after)
    after_c = get_next(cups, c)
    cups = Map.put(cups, insert_after, a)
    |> Map.put(c, close)
    |> Map.put(current, after_c)
    {get_next(cups, current), cups}
  end

 
  def simulate(current_and_cups, rounds \\ 100)
  def simulate({_current, cups}, 0), do: cups
  def simulate({current, cups}, n), do: simulate(play_round(current, cups), n - 1)

  def grab_number(cups) do
    {bef, aft} = Enum.split_while(cups, &(&1 != 1))
    tl(aft) ++ bef
    |> Enum.map(&to_string/1)
    |> Enum.join()
  end

  def make_a_million(list) do
    list ++ Enum.to_list((Enum.max(list) + 1)..1_000_000)
  end

  def build_list(first, [a]), do: Map.put(%{}, a, first)
  def build_list(first, [a, b | rest]) do
    Map.put(build_list(first, [b | rest]), a, b)
  end

  def to_nodes(list) do
    build_list(hd(list), list)
  end

  def solve() do
    numbers = read_line()
    |> String.graphemes()
    |> Enum.map(&int/1)
    |> make_a_million()
    
    nodes = to_nodes(numbers)
    simulate({hd(numbers), nodes}, 10_000_000)
    |> get_next(1, 2)
    |> Enum.reduce(&Kernel.*/2)
    |> IO.inspect()
    #|> grab_number()
    #|> IO.puts()
  end
end
