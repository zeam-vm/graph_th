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

  def is_simple?(path) when is_struct(path) do
    length(Enum.uniq(path.path)) == length(path.path)
  end

  def length_p(%GraphTh.Path{path: []}) do
    0
  end

  def length_p(path) when is_struct(path) do
    length(path.path) - 1
  end

  def is_null?(path) when is_struct(path) do
    length_p(path) == 0
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
