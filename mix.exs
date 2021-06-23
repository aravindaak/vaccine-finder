defmodule Cowin.MixProject do
  use Mix.Project

  def project do
    [
      app: :cowin,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Cowin.Application, []},
      extra_applications: [:logger, :runtime_tools],
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.14"},
      {:phoenix_pubsub, "~> 1.1"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.8"},
      {:telegram, git: "https://github.com/visciang/telegram.git"},
      {:tesla, "~> 1.4.0"},

    # optional, but recommended adapter
    {:hackney, "~> 1.17.0"},

    # optional, required by JSON middleware
    ]
  end
end
