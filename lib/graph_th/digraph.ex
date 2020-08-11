defmodule GraphTh.Digraph do
  defstruct arcs: %{}

  def empty() do
    %GraphTh.Digraph{arcs: %{}}
  end

  def has_vertice?(g, v) when is_struct(g) and is_atom(v) do
    Map.has_key?(g.arcs, v)
  end

  def has_arc?(g, {v1, v2}) when is_struct(g) and is_atom(v1) and is_atom(v2) do
    k = Map.get(g.arcs, v1)

    if is_nil(k) do
      false
    else
      k |> Enum.any?(&(&1 == v2))
    end
  end

  def add_vertice(g, v) when is_struct(g) and is_atom(v) do
    if has_vertice?(g, v) do
      g
    else
      %GraphTh.Digraph{arcs: Map.put(g.arcs, v, [])}
    end
  end

  def add_arc(g, {v1, v2}) when is_struct(g) and is_atom(v1) and is_atom(v2) do
    cond do
      has_vertice?(g, v1) == false ->
        %GraphTh.Digraph{arcs: Map.put(g.arcs, v1, [v2])} |> add_vertice(v2)

      has_arc?(g, {v1, v2}) == false ->
        %GraphTh.Digraph{arcs: Map.put(g.arcs, v1, Map.get(g.arcs, v1) ++ [v2])}
        |> add_vertice(v2)

      true ->
        g
    end
  end

  def remove_arc(g, {v1, v2}) when is_struct(g) and is_atom(v1) and is_atom(v2) do
    cond do
      has_vertice?(g, v1) == false ->
        g

      has_arc?(g, {v1, v2}) == false ->
        g

      true ->
        %GraphTh.Digraph{
          arcs: Map.put(g.arcs, v1, Map.get(g.arcs, v1) |> Enum.filter(&(&1 != v2)))
        }
    end
  end

  def subgraph?(g1, g2) when is_struct(g1) and is_struct(g2) do
    subvertices?(g1, g2) and subarcs?(g1, g2)
  end

  defp subvertices?(g1, g2) when is_struct(g1) and is_struct(g2) do
    Map.keys(g2.arcs) |> Enum.all?(&has_vertice?(g1, &1))
  end

  defp subarcs?(g1, g2) when is_struct(g1) and is_struct(g2) do
    g2.arcs
    |> Enum.all?(fn {k, v} -> v |> Enum.all?(&has_arc?(g1, {k, &1})) end)
  end
end
