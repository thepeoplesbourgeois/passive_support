defmodule PassiveSupport.Mixfile do
  use Mix.Project

  def project do
    [app: :passive_support,
     version: "0.6.2",
     elixir: "~> 1.9",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     xref: xref(Mix.env)]
  end

  defp xref(env) when env in [:dev, :test], do: [exclude: [IEx, IEx.Pry]]
  defp xref(_), do: []

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: extra_apps(Mix.env)]
  end

  def extra_apps(:test), do: extra_apps(:dev)
  def extra_apps(:dev), do: [:iex | [:os_mon | extra_apps(:prod)]]
  def extra_apps(_), do: [:logger, :runtime_tools]

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:benchee, "~> 1.0.1", only: :dev},
      {:ex_doc, ">= 0.0.0"}
    ]
  end
end
