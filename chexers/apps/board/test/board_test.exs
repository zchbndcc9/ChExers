defmodule BoardTest do
  use ExUnit.Case
  doctest Board

  test "greets the world" do
    assert Board.hello() == :world
  end
end
