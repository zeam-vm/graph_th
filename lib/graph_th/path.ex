defmodule GraphTh.Path do
  defstruct path: []

  def empty() do
    %GraphTh.Path{path: []}
  end

  def path(p) when is_list(p) do
    %GraphTh.Path{path: p}
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
