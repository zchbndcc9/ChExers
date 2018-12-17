defmodule GameManagerTest do
  use ExUnit.Case
  doctest GameManager

  test "greets the world" do
    assert GameManager.hello() == :world
  end
end
