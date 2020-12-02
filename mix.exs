defmodule Aoc2020.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc_2020,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
    [
      {:benchee, "~> 1.0"},
      {:exsync, ">= 0.0.0", only: :dev, runtime: true},
      {:mix_test_watch, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
