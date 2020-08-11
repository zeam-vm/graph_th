defmodule Digraph do
  defstruct arcs: %{}

  def empty() do
    %Digraph{arcs: %{}}
  end

  def has_vertice?(g, v) when is_struct(g) and is_atom(v) do
    Map.has_key?(g.arcs, v)
  end

  def has_arc?(g, {v1, v2}) when is_struct(g) and is_atom(v1) and is_atom(v2) do
    Map.get(g.arcs, v1) |> Enum.any?(&(&1 == v2))
  end

  def add_vertice(g, v) when is_struct(g) and is_atom(v) do
    if has_vertice?(g, v) do
      g
    else
      %Digraph{arcs: Map.put(g.arcs, v, [])}
    end
  end

  def add_arc(g, {v1, v2}) when is_struct(g) and is_atom(v1) and is_atom(v2) do
    cond do
      has_vertice?(g, v1) == false ->
        %Digraph{arcs: Map.put(g.arcs, v1, [v2])}

      has_arc?(g, {v1, v2}) == false ->
        %Digraph{arcs: Map.put(g.arcs, v1, Map.get(g.arcs, v1) ++ [v2])}

      true ->
        g
    end
  end
end
