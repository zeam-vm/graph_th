defmodule GraphTh.Path do
  @moduledoc """
  GraphTh.Path is a path.
  """

  defstruct path: []

  @doc """
  Generate an empty path.

  ## Examples

    iex> GraphTh.Path.empty()
    %GraphTh.Path{path: []}
  """
  def empty() do
    %GraphTh.Path{path: []}
  end

  @doc """
  Generate a path from the given `path_list`.

  ## Examples

    iex> GraphTh.Path.path([:a, :b])
    %GraphTh.Path{path: [:a, :b]}
  """
  def path(path_list) when is_list(path_list) do
    %GraphTh.Path{path: path_list}
  end

  @doc """
  Returns whether the given `path` is simple, that is, all vertices on `path` are distinct.

  ## Examples

    iex> GraphTh.Path.is_simple?(GraphTh.Path.path([:a, :b]))
    true
    iex> GraphTh.Path.is_simple?(GraphTh.Path.path([:a, :b, :a]))
    false
  """
  def is_simple?(path) when is_struct(path) do
    length(Enum.uniq(path.path)) == length(path.path)
  end

  @doc """
  Returns the length of `path`.

  ## Examples

    iex> GraphTh.Path.length_p(GraphTh.Path.empty())
    0
    iex> GraphTh.Path.length_p(GraphTh.Path.path([:a]))
    0
    iex> GraphTh.Path.length_p(GraphTh.Path.path([:a, :b]))
    1
    iex> GraphTh.Path.length_p(GraphTh.Path.path([:a, :b, :c]))
    2
  """
  def length_p(%GraphTh.Path{path: []}) do
    0
  end

  def length_p(path) when is_struct(path) do
    length(path.path) - 1
  end

  @doc """
  Returns whether the given `path` is trivial, that is, with zero length consists of a single vertex.

  ## Examples

    iex> GraphTh.Path.is_trivial?(GraphTh.Path.empty())
    true
    iex> GraphTh.Path.is_trivial?(GraphTh.Path.path([:a]))
    true
    iex> GraphTh.Path.is_trivial?(GraphTh.Path.path([:a, :b]))
    false
    iex> GraphTh.Path.is_trivial?(GraphTh.Path.path([:a, :b, :c]))
    false
  """
  def is_trivial?(path) when is_struct(path) do
    length_p(path) == 0
  end

  @doc """
  Returns a directed graph representation of the given `path`.

  ## Examples

    iex> GraphTh.Path.induced_graph(GraphTh.Path.empty())
    %GraphTh.Digraph{arcs: %{}}
    iex> GraphTh.Path.induced_graph(GraphTh.Path.path([:a]))
    %GraphTh.Digraph{arcs: %{a: []}}
    iex> GraphTh.Path.induced_graph(GraphTh.Path.path([:a, :b]))
    %GraphTh.Digraph{arcs: %{a: [:b], b: []}}
    iex> GraphTh.Path.induced_graph(GraphTh.Path.path([:a, :b, :c]))
    %GraphTh.Digraph{arcs: %{a: [:b], b: [:c], c: []}}
  """
  def induced_graph(%GraphTh.Path{path: [vertice]}) do
    GraphTh.Digraph.empty() |> GraphTh.Digraph.add_vertice(vertice)
  end

  def induced_graph(path) when is_struct(path) do
    Enum.zip([nil] ++ path.path, path.path ++ [nil])
    |> Enum.reduce(
      GraphTh.Digraph.empty(),
      fn
        {_, nil}, g -> g
        {nil, _}, g -> g
        {v1, v2}, g -> GraphTh.Digraph.add_arc(g, {v1, v2})
      end
    )
  end
end
