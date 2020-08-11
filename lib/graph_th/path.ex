defmodule GraphTh.Path do
  defstruct path: []

  def empty() do
    %GraphTh.Path{path: []}
  end

  def is_simple?(path) when is_struct(path) do
    length(Enum.uniq(path.path)) == length(path.path)
  end
end
