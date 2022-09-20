defmodule NMTest do
  use ExUnit.Case
  doctest NM

  test "greets the world" do
    assert NM.hello() == :world
  end
end
