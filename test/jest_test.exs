defmodule JestTest do
  use ExUnit.Case
  doctest Jest

  test "greets the world" do
    assert Jest.hello() == :world
  end
end
