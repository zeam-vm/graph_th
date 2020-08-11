defmodule GraphTh.MixProject do
  use Mix.Project

  def project do
    [
      app: :graph_th,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: [
        api_reference: false,
        main: "GraphTh"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    []
  end

  defp description() do
    "GraphTh is a library for graph theory."
  end

  defp package() do
    [
      name: "graph_th",
      maintainers: [
        "Susumu Yamazaki"
      ],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/zeam-vm/graph_th"}
    ]
  end
end
