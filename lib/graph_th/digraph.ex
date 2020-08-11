defmodule Digraph do
  defstruct arcs: %{}

  def di_graph() do
    %Digraph{arcs: %{}}
  end
end