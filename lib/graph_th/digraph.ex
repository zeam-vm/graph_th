defmodule GraphTh.Digraph do
  @moduledoc """
  GraphTh.Digraph is a directed graph.
  """

  defstruct arcs: %{}

  @doc """
  Generate an empty directed graph.

  ## Examples

    iex> GraphTh.Digraph.empty()
    %GraphTh.Digraph{arcs: %{}}
  """
  def empty() do
    %GraphTh.Digraph{arcs: %{}}
  end

  @doc """
  Returns whether the given `vertice` exists in the given `graph`.

  ## Examples

    iex> GraphTh.Digraph.has_vertice?(GraphTh.Digraph.empty(), :a)
    false
    iex> GraphTh.Digraph.has_vertice?(%GraphTh.Digraph{arcs: %{a: []}}, :a)
    true
    iex> GraphTh.Digraph.has_vertice?(%GraphTh.Digraph{arcs: %{a: []}}, :b)
    false
  """
  def has_vertice?(g, v) when is_struct(g) do
    Map.has_key?(g.arcs, v)
  end

  def has_arc?(g, {v1, v2}) when is_struct(g) do
    k = Map.get(g.arcs, v1)

    if is_nil(k) do
      false
    else
      k |> Enum.any?(&(&1 == v2))
    end
  end

  def add_vertice(g, v) when is_struct(g) do
    if has_vertice?(g, v) do
      g
    else
      %GraphTh.Digraph{arcs: Map.put(g.arcs, v, [])}
    end
  end

  def add_arc(g, {v1, v2}) when is_struct(g) do
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

  def remove_arc(g, {v1, v2}) when is_struct(g) do
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

  def include_path?(g, path) when is_struct(g) and is_struct(path) do
    subgraph?(g, GraphTh.Path.induced_graph(path))
  end
end
