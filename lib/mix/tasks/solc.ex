defmodule Mix.Tasks.Tulip.Solc do
  use Mix.Task

  @shortdoc "Runs the solc compiler to create binary and abi of all contracts. Outputs to build directory"
  def run(_) do
    # calling our Hello.say() function from earlier
    Mix.Shell.IO.cmd("solc -o build --abi --bin contracts/* --overwrite")
  end
end
