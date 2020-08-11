defmodule Digraph do
  defstruct arcs: %{}

  def di_graph() do
    %Digraph{arcs: %{}}
  end

  def has_vertice?(g, v) when is_struct(g) and is_atom(v) do
    Map.has_key?(g.arcs, v)
  end
end