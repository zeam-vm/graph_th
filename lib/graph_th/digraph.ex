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
  def has_vertice?(graph, vertice) when is_struct(graph) do
    Map.has_key?(graph.arcs, vertice)
  end

  @doc """
  Returns whether the given arc from `vertice1` to `vertice2` exists in the given `graph`.

  ## Examples

    iex> GraphTh.Digraph.has_arc?(GraphTh.Digraph.empty(), {:a, :b})
    false
    iex> GraphTh.Digraph.has_arc?(%GraphTh.Digraph{arcs: %{a: [:b], b: []}}, {:a, :b})
    true
    iex> GraphTh.Digraph.has_arc?(%GraphTh.Digraph{arcs: %{a: [:b], b: []}}, {:a, :c})
    false
  """
  def has_arc?(graph, {vertice1, vertice2}) when is_struct(graph) do
    k = Map.get(graph.arcs, vertice1)

    if is_nil(k) do
      false
    else
      k |> Enum.any?(&(&1 == vertice2))
    end
  end

  @doc """
  Returns a directed graph with `vertice` added to the given `graph`.

  ## Examples

    iex> GraphTh.Digraph.add_vertice(GraphTh.Digraph.empty(), :a)
    %GraphTh.Digraph{arcs: %{a: []}}
    iex> GraphTh.Digraph.add_vertice(%GraphTh.Digraph{arcs: %{a: []}}, :a)
    %GraphTh.Digraph{arcs: %{a: []}}
    iex> GraphTh.Digraph.add_vertice(%GraphTh.Digraph{arcs: %{a: []}}, :b)
    %GraphTh.Digraph{arcs: %{a: [], b: []}}    
  """
  def add_vertice(graph, vertice) when is_struct(graph) do
    if has_vertice?(graph, vertice) do
      graph
    else
      %GraphTh.Digraph{arcs: Map.put(graph.arcs, vertice, [])}
    end
  end

  @doc """
  Returns a directed graph with an arc from `vertice1` to `vertice2` added to the given `graph`.

  ## Examples

    iex> GraphTh.Digraph.add_arc(GraphTh.Digraph.empty(), {:a, :b})
    %GraphTh.Digraph{arcs: %{a: [:b], b: []}}
    iex> GraphTh.Digraph.add_arc(%GraphTh.Digraph{arcs: %{a: [:b], b: []}}, {:a, :b})
    %GraphTh.Digraph{arcs: %{a: [:b], b: []}}
    iex> GraphTh.Digraph.add_arc(%GraphTh.Digraph{arcs: %{a: [:b], b: []}}, {:b, :c})
    %GraphTh.Digraph{arcs: %{a: [:b], b: [:c], c: []}}
    iex> GraphTh.Digraph.add_arc(%GraphTh.Digraph{arcs: %{a: [:b], b: []}}, {:a, :c})
    %GraphTh.Digraph{arcs: %{a: [:b, :c], b: [], c: []}}
  """
  def add_arc(graph, {vertice1, vertice2}) when is_struct(graph) do
    cond do
      has_vertice?(graph, vertice1) == false ->
        %GraphTh.Digraph{arcs: Map.put(graph.arcs, vertice1, [vertice2])}
        |> add_vertice(vertice2)

      has_arc?(graph, {vertice1, vertice2}) == false ->
        %GraphTh.Digraph{
          arcs:
            Map.put(
              graph.arcs,
              vertice1,
              Map.get(graph.arcs, vertice1) ++ [vertice2]
            )
        }
        |> add_vertice(vertice2)

      true ->
        graph
    end
  end

  def delete_arc(graph, {vertice1, vertice2}) when is_struct(graph) do
    cond do
      has_vertice?(graph, vertice1) == false ->
        graph

      has_arc?(graph, {vertice1, vertice2}) == false ->
        graph

      true ->
        %GraphTh.Digraph{
          arcs:
            Map.put(
              graph.arcs,
              vertice1,
              Map.get(graph.arcs, vertice1)
              |> Enum.filter(&(&1 != vertice2))
            )
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
