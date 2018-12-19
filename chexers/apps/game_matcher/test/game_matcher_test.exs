defmodule GameMatcherTest do
  use ExUnit.Case
  doctest GameMatcher

  test "greets the world" do
    assert GameMatcher.hello() == :world
  end
end
