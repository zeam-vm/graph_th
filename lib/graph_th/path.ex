defmodule GraphTh.Path do
  defstruct path: []

  def empty() do
    %GraphTh.Path{path: []}
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
end
