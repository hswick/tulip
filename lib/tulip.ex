defmodule Tulip do

  def load_contract_artifacts(name, options) do
    {abi_path, bin_path} =
    if options[:build_path] do
      path = "#{options[:build_path]}#{name}"
      {"#{path}.abi", "#{path}.bin"}
    else
      {"./build#{name}.abi", "./build/#{name}.bin"}
    end
    
    abi = ExW3.load_abi abi_path
    bin = ExW3.load_bin bin_path

    {abi, bin}
  end

  def deploy_contract(atom, args, options, tulip_options \\ []) do

    contract_name =
      atom
      |> Atom.to_string
      |> String.split(".")
      |> Enum.at(1)

    {abi, bin} = load_contract_artifacts(contract_name, tulip_options)
    
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
	address
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

  def deploy_contracts(contract_configs, tulip_options) do

    accounts = ExW3.accounts
    default_config = %{from: Enum.at(accounts, 0), gas: 300_000}
    
    name_address_tuples =
      Enum.map(contract_configs, fn config ->
	{atom, args, options} = parse_config(config)
	deploy_contract(
	  atom,
	  translate_args(args),
	  Map.merge(default_config, Enum.into(options, %{})),
	  tulip_options
	)
      end)

    input = System.argv()

    network =
    if input == [] || tulip_options[:test] do
      "development"
    else
      Enum.at(input, 0)
    end

    build_path =
    if tulip_options[:build_path] do
      tulip_options[:build_path]
    else
      "./build/"
    end

    File.write(
      "#{build_path}#{network}.json",
      name_address_tuples
      |> Enum.into(%{})
      |> Poison.encode!
    )
  end

  def init_artifacts_context(network, options) do
    build_path =
    if options[:build_path] do
      options[:build_path]
    else
      "./build/"
    end
    
    addresses = Poison.decode!(File.read!("#{build_path}#{network}.json"))

    contracts = 
      Enum.map(addresses, fn {contract_name, address} ->
        abi = ExW3.load_abi("#{build_path}#{contract_name}.abi")
        bin = ExW3.load_bin("#{build_path}#{contract_name}.bin")
        {String.to_atom(contract_name), %{address: address, abi: abi, bin: bin}}
      end)
    
    Map.merge(%{network: network, accounts: ExW3.accounts()}, Enum.into(contracts, %{}))
  end
  
  def get_artifacts(options) do

    input = System.argv()

    network =
    if Kernel.length(input) == 1 do
      "development"
    else
      if options[:test] do
        Enum.at(input, 1)
      else
        Enum.at(input, 0)
      end
    end
    
    init_artifacts_context(network, options)
  end
end
