defmodule TulipTest do
  use ExUnit.Case
  doctest Tulip
  
  test "load contract artifacts" do
    {abi, bin} = Tulip.load_contract_artifacts("SimpleStorage", build_path: "./test/build/")

    assert abi |> is_map
    assert bin |> is_binary
  end

  test "deploys contract" do
    {name, address} = Tulip.deploy_contract(
      SimpleStorage,
      [],
      [from: Enum.at(ExW3.accounts, 0), gas: 300_000],
      build_path: "./test/build/"
    )

    assert name |> is_binary
    assert address |> is_binary

  end

  test "deploys contracts and gets artifacts" do
    result = Tulip.deploy_contracts([SimpleStorage], build_path: "./test/build/", test: true)
    assert(result == :ok)

    artifacts = Tulip.get_artifacts(build_path: "./test/build/")

    assert artifacts[:SimpleStorage] |> is_map
    assert artifacts[:SimpleStorage][:abi] |> is_map
    assert artifacts[:SimpleStorage][:bin] |> is_binary
    assert artifacts[:SimpleStorage][:address] |> is_binary
    assert artifacts[:accounts] |> is_list
    assert artifacts[:network] |> is_binary

  end

end
