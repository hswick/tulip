# <%= module_name %>

This is a super duper Dapp!

To compile the smart contracts run `mix tulip.solc`

Then you will need to deploy them with `mix tulip.deploy`

*NOTE* before you can successfully deploy your contracts ensure there is an ethereum node you can connect to. An easy way to get started is with `ganache-cli`. You can install it with `npm install -g ganache-cli`, then in a separate tab run `ganache-cli`. If you have a node running on a different port, simply update the `config.exs` file with the proper port number.

Once the above steps are complete you can make sure everything is working with
`mix test`


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `<%= project_name %>` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:<%= project_name %>, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/<%= project_name %>](https://hexdocs.pm/<%= project_name %>).

