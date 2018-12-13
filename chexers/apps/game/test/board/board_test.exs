defmodule Game.BoardTest do
  use ExUnit.Case
  alias Game.Board

  describe "when default board is created," do
    setup do
      board = Board.create()
      {:ok, board: board}
    end

    test "the size is correct", context do
      size = context[:board] |> Enum.count()
      assert size === 64
    end

    test "it contains the correct number of movable spaces", context do
      num_spaces =
        context[:board]
        |> Enum.filter(fn cell -> cell.movable? === true end)
        |> Enum.count()
      assert num_spaces === 32
    end
  end

  describe "when dimension is supplied to board," do
    setup do
      board = Board.create(10)
      {:ok, board: board}
    end

    test "the size is correct", context do
      size = context[:board] |> Enum.count()
      assert size === 100
    end

    test "it contains the correct number of movable spaces", context do
      num_spaces =
         context[:board]
         |> Enum.filter(fn cell -> cell.movable? === true end)
         |> Enum.count()
      assert num_spaces === 50
    end
  end

  test "board not created when invalid size is supplied" do
    assert_raise ArgumentError, fn -> Board.create("hello") end
    assert_raise ArgumentError, fn -> Board.create(-4) end
  end
end
