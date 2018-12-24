defmodule Game.BoardTest do
  use ExUnit.Case
  alias Game.Board

  setup_all do
    {_status, board} = Board.create()
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

  describe "board not created when" do
    test "non-integer supplied" do
      {status, _} = Board.create(4.0001)
      assert status === :error
      {status, _} = Board.create("hello")
      assert status === :error
      {status, _} = Board.create(:world)
      assert status === :error
    end

    test "negative integer supplied" do
      {status, _} = Board.create(-4)
      assert status === :error
    end

    test "zero size supplied" do
      {status, _} = Board.create(0)
      assert status === :error
    end
  end

  describe "when cell is retrieved" do
    test "it returns with correct coords", state do
      {status, cell} = Board.get_cell(state[:board], 2, 3)
      assert status === :ok
      assert cell.row === 2
      assert cell.col === 3
    end

    test "there is no result if no cell exists at that coordinate", state do
      {status, _cell} = Board.get_cell(state[:board], 20, 3)
      assert status === :error
    end
  end
end
