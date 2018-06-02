defmodule <%= @project_name %>Test do
  use ExUnit.Case
  doctest <%= @project_name %>

  test "greets the world" do
    assert <%= @project_name %>.hello() == :world
  end
end
