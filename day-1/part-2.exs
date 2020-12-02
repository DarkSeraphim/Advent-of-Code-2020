solve_for_n = fn(elements, target) ->
  elements
  |> Enum.reduce_while(%{}, fn(num, req) ->
    if Map.has_key?(req, num) do 
      {:halt, {:halt, Map.get(req, num) * num}}
    else
      {:cont, Map.put(req, target - num, num)}
    end
  end)
end

IO.read(:stdio, :all)
|> String.trim_trailing()
|> String.split("\n")
|> Enum.map(&Kernel.elem(Integer.parse(&1, 10), 0))
|> Enum.reduce(%{}, fn(num, req) ->
    Map.put(req, 2020 - num, num)
  end)

|> fn(part) ->
  part
  |> Map.to_list()
  |> Enum.reduce_while(nil, fn({left, first}, nop) ->
      Map.values(part)
      |> Enum.filter(&(&1 != first))
      |> solve_for_n.(left)
      |> case do
          {:halt, x} -> {:halt, x * first}
          _ -> {:cont, nop}
        end
    end)
  |> IO.puts
end.()

