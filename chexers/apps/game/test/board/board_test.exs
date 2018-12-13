defmodule Game.BoardTest do
  use ExUnit.Case
  alias Game.Board

  setup_all do
    board = Board.create()
    {:ok, board: board}
  end
  describe "when default board is created," do
    test "the size is correct", state do
      size = state[:board] |> Enum.count()
      assert size === 64
    end

    test "it contains the correct number of movable spaces", state do
      num_spaces =
        state[:board]
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

  describe "when cell is retrieved" do
    test "it returns with correct coords", state do
      {status, cell} = Board.get_cell(2, 3)
      assert status === :ok
      assert cell.row === 2
      assert cell.col === 3
    end

    test "there is no result if no cell exists at that coordinate", state do
      {status, _cell} = Board.get_cell(20, 3)
      assert status === :error
      assert cell === "no cell exists"
    end
  end
end
