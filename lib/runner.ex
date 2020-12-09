defmodule Runner do
  use Application
  
  def start(_type, _args) do
    [_, day, part | _] = System.argv()
    apply(String.to_atom("Elixir.Day#{day}_#{part}"), :solve, [])
    {:ok, self()}
  end

end
