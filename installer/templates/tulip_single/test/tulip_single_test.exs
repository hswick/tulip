defmodule <%= module_name %>Test do
  use ExUnit.Case
  doctest <%= module_name %>

  setup_all do
    Tulip.get_artifacts()  
  end

  test "uses Simple Storage contract", context do
    ExW3.Contract.start_link(
      SimpleStorage,
      :abi context[:SimpleStorage][:abi],
      :address context[:SimpleStorage][:address]
    )

    assert <%= module_name %>.get() == {:ok, 0}

    <%= module_name %>.set(1, {from: Enum.at(context[:accounts], 0)})

    assert <%= module_name %>.get() == {:ok, 0}
    
  end
end
