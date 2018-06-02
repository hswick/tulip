defmodule Tulip do

  def deploy_contract(atom, args, options) do

    contract_name =
      atom
      |> Atom.to_string
      |> String.split(".")
      |> Enum.at(1)	
    
    abi = ExW3.load_abi "./build/#{contract_name}.abi"
    bin = ExW3.load_bin "./build/#{contract_name}.bin"
    
    ExW3.Contract.start_link(atom, abi: abi)
    
    {:ok, address} = ExW3.Contract.deploy(atom, bin: bin, args: args, options: options)

    ExW3.Contract.at(atom, address)

    {contract_name, address}
  end

  def translate_args(args) do
    Enum.map(args, fn arg ->
      if arg |> is_atom do
        address = 
          ExW3.Contract.address(arg) 
          |> ExW3.format_address
      else
	arg
      end
    end)
  end

  def parse_config(config) do
    case config do
      [atom, args: args, options: options] -> {atom, args, options}
      [atom, args: args] -> {atom, args, []}
      [atom, options: options] -> {atom, [], options}
      atom -> {atom, [], []}
    end
  end

  def deploy_contracts(contract_configs) do

    accounts = ExW3.accounts
    
    name_address_tuples =
      Enum.map(contract_configs, fn config ->
	{atom, args, options} = parse_config(config)
	default_config = %{from: Enum.at(accounts, 0), gas: 300_000}
	deploy_contract(atom, translate_args(args), Map.merge(default_config, Enum.into(options, %{})))
      end)

    input = System.argv()

    network =
    if input == [] do
      "development"
    else
      Enum.at(input, 0)
    end

    File.write(
      "./build/#{network}.json",
      name_address_tuples
      |> Enum.into(%{})
      |> Poison.encode!
    )
  end

  def init_artifacts_context(network) do
    addresses = Poison.decode!(File.read!("./build/#{network}.json"))

    contracts = 
      Enum.map(addresses, fn {contract_name, address} ->
        abi = ExW3.load_abi("./build/#{contract_name}.abi")
        bin = ExW3.load_bin("./build/#{contract_name}.bin")
        {String.to_atom(contract_name), %{address: address, abi: abi, bin: bin}}
      end)
    
    Map.merge(%{network: network, accounts: ExW3.accounts()}, Enum.into(contracts, %{}))  
  end
  
  def get_artifacts(is_test \\ false) do

    input = System.argv()

    network =
    if Kernel.length(input) == 1 do
      "development"
    else
      if is_test do
        Enum.at(input, 1)
      else
        Enum.at(input, 0)
      end
    end
    
    init_artifacts_context(network)
  end
end
