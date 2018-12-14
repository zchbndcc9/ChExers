defmodule Game.Move.ValidatorTest do
  use ExUnit.Case
  alias Game.Move.Validator

  setup_all do
    {_status, game} = Game.new_game()
    {:ok, game: {:ok, game}}
  end

  describe "invalid coordinates flag" do
    test "raised", state do
      {status, _game} = Validator.check_valid_coord(state[:game], %{row: 100, col: 32})
      assert status === :invalid_coord
    end

    test "not raised", state do
      {status, _game} = Validator.check_valid_coord(state[:game], %{row: 5, col: 5})
      assert status === :ok
    end
  end

  describe "same location flag" do
    test "raised", state do
      {status, _game} = Validator.check_same_location(state[:game], %{row: 5, col: 5}, %{row: 5, col: 5})
      assert status === :same_location
    end

    test "not raised", state do
      {status, _game} = Validator.check_same_location(state[:game], %{row: 5, col: 5}, %{row: 6, col: 5})
      assert status === :ok
    end
  end

  describe "piece exists flag" do
    test "raised", state do
      {status, _game} = Validator.check_piece_exists(state[:game], %{row: 4, col: 4})
      assert status === :no_piece
    end

    test "not raised", state do
      {status, _game} = Validator.check_piece_exists(state[:game], %{row: 1, col: 1})
      assert status === :ok
    end
  end

  describe "wrong piece flag" do
    test "raised", state do
      {status, _game} = Validator.check_right_piece(state[:game], :red, %{row: 1, col: 0})
      assert status === :wrong_piece
    end

    test "not raised", state do
      {status, _game} = Validator.check_right_piece(state[:game], :white, %{row: 1, col: 1})
      assert status === :ok
    end
  end

  describe "invalid move flag" do
    test "raised", state do
      {status, _game} = Validator.check_valid_move(state[:game], %{row: 2, col: 2}, %{row: 2, col: 5})
      assert status === :invalid_move
      {status, _game} = Validator.check_valid_move(state[:game], %{row: 2, col: 2}, %{row: 4, col: 3})
      assert status === :invalid_move
    end

    test "not raised", state do
      {status, _game} = Validator.check_valid_move(state[:game], %{row: 2, col: 2}, %{row: 3, col: 3})
      assert status === :ok
      {status, _game} = Validator.check_valid_move(state[:game], %{row: 2, col: 2}, %{row: 4, col: 4})
      assert status === :possible_hop
    end
  end

  describe "occupied flag" do
    test "raised", state do
      {status, _game} = Validator.check_occupied(state[:game], %{row: 5, col: 1})
      assert status === :blocked
    end

    test "not raised", state do
      {status, _game} = Validator.check_occupied(state[:game], %{row: 4, col: 4})
      assert status === :ok
    end
  end
end
