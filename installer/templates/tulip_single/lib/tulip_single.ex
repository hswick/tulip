defmodule <%= module_name %> do
  @moduledoc """
  Documentation for <%= module_name %>.
  """

  def set(num, options) do
    ExW3.Contract.send(SimpleStorage, :set [num], options)
  end

  def get() do
    ExW3.Contract.call(SimpleStorage, :get)
  end
end
