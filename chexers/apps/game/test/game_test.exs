defmodule GameTest do
  use ExUnit.Case
  alias Game.Board
  alias Game.Board.Cell

  setup_all do
    {_status, game} = Game.new_game()
    {:ok, game: game}
  end

  describe "when default game is created" do
    test "it contains the correct number of player pieces", state do
      assert state[:game].game_pieces.white === 12
      assert state[:game].game_pieces.black === 12
    end
  end

  describe "when player moves piece" do
    test "the status is correct", state do
      {status, _game} = Game.move(state[:game], :black, %{row: 5, col: 1}, %{row: 4, col: 0})
      assert status === :ok
    end
    test "it alters the board", state do
      {_status, game} = Game.move(state[:game], :black, %{row: 5, col: 1}, %{row: 4, col: 0})
      assert Board.get_cell(game.board, 5, 1) === {:ok, %Cell{ row: 5, col: 1, occupier: nil, movable?: true}}
      assert Board.get_cell(game.board, 4, 0) === {:ok, %Cell{ row: 4, col: 0, occupier: :black, movable?: true}}
    end
  end
end
