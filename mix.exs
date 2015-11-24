defmodule Netconn2syslog.Mixfile do
  use Mix.Project

  def project do
    [app: :netconn2syslog,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cbserverapi2, :gproc]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
 #     {:cbserverapi2, path: "../cbserverapi2"},
      {:cbserverapi2, git: "https://github.com/redvers/cbserverapi2.git"},
      {:gproc, "~> 0.5.0"}
    ]
  end
end
