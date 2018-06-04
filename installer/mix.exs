defmodule Tulip.New.MixProject do
  use Mix.Project

  def project do
    [
      app: :tulip_new,
      version: version(),
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: []
    ]
  end

  def version, do: "0.1.0"

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp aliases do
    [
      build: [ &build_releases/1],
    ]
  end

  defp build_releases(_) do
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run([])
    Mix.Tasks.Archive.Build.run(["--output=tulip.new.ez"])
    File.rename("tulip.new.ez", "./tulip_archives/tulip.new.ez")
    File.rename("tulip_new-#{version()}.ez", "./tulip_archives/tulip.new-#{version()}.ez")
  end
end
