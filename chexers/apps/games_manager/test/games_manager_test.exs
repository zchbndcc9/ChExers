defmodule GamesManagerTest do
  use ExUnit.Case
  doctest GamesManager

  test "greets the world" do
    assert GamesManager.hello() == :world
  end
end
