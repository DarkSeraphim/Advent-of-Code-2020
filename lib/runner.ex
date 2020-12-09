defmodule Runner do
  use Application
  
  def start(_type, _args) do
    args = System.argv()
    day = Enum.at(args, 1)
    part = Enum.at(args, 2)
    target_name = "Elixir.Day#{day}_#{part}"
    apply(String.to_atom(target_name), :solve, [])
    {:ok, self()}
  end

end
