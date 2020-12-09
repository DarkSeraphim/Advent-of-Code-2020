defmodule Common do
  def read_lines(delimiter \\ "\n") do
    IO.read(:stdio, :all)
    |> String.trim_trailing()
    |> String.split(delimiter)
  end

  def int(s), do: String.to_integer(s)
end
