defmodule GameTest do
  use ExUnit.Case
  alias Game.Board
  alias Game.Board.Cell

  setup_all do
    game = Game.new_game()
    {:ok, game: game}
  end

  describe "when default game is created" do
    test "it contains the correct number of player pieces", state do
      assert state[:game].white_pieces === 12
      assert state[:game].black_pieces === 12
    end
  end

  describe "when player moves piece" do
    test "it alters the board", state do
      game = Game.move(state[:game], :white, %{row: 5, col: 1}, %{row: 4, col: 0})
      assert Board.get_cell(game.board, 5, 1) === %Cell{ row: 5, col: 1, occupier: :white }
      assert Board.get_cell(game.board, 4, 0) === %Cell{ row: 4, col: 0, occupier: nil }
    end
  end

  describe "piece is not moved if" do
    test "the player tries to move a nonexistent piece", state do
      game = Game.move(state[:game], :white, %{row: 4, col: 4}, %{row: 4, col: 5})
      assert game.move_status === :no_piece
      assert Board.equal?(game.board, state[:game].board) === true
    end

    test "the player tries to move a piece that isn't theirs", state do
      game = Game.move(state[:game], :white, %{row: 4, col: 4}, %{row: 4, col: 5})
      assert game.move_status === :cannot_move
      assert Board.equal?(game.board, state[:game].board) === true
    end

    test "the destination is too far", state do
      game = Game.move(state[:game], :white, %{row: 2, col: 2}, %{row: 2, col: 3})
      assert game.move_status === :too_far
      assert Board.equal?(game.board, state[:game].board) === true
    end

    test "the destination is occupied", state do
      game = Game.move(state[:game], :white, %{row: 6, col: 2}, %{row: 5, col: 1})
      assert game.move_status === :blocked
      assert Board.equal?(game.board, state[:game].board) === true
    end
  end
end
