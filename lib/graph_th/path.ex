defmodule GraphTh.Path do
  defstruct path: []

  def empty() do
    %GraphTh.Path{path: []}
  end
end
