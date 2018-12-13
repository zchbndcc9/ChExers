defmodule Game.BoardTest do
  use ExUnit.Case
  alias Game.Board

  describe "board created when" do
    test "no size included (default)" do
      board = Board.create()
      assert board |> Enum.count() === 64
      assert board |> Enum.filter(fn cell -> cell.movable? === true end) |> Enum.count() === 32
    end

    test "dimensions supplied" do
      board = Board.create(10)
      assert board |> Enum.count() === 100
      assert board |> Enum.filter(fn cell -> cell.movable? === true end) |> Enum.count() === 50
    end
  end

  describe "board not created when" do
    test "invalid size input" do
      assert_raise ArgumentError, fn -> Board.create("hello") end
      assert_raise ArgumentError, fn -> Board.create(-4) end
    end
  end
end
