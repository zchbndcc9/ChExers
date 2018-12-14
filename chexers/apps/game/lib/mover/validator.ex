defmodule Game.Move.Validator do
  alias Game.Board
  alias Game.Board.Cell

  @type coords :: %{ row: integer, col: integer }
  @type player :: :white | :black
  @type move_flag ::  :ok | :invalid_move | :wrong_piece |
                      :invalid_coord | :no_piece |
                      :possible_hop | :invalid_hop | :hop |
                      :blocked | :same_location

  @moduledoc """
  Contains all functions pertaining to the validity of a move in checkers.
  This includes ensuring that player does not attempt to move opponents pieces,
  to move to an invalid board cell, nor to hop over an invalid number of cells
  """

  @spec validate(%Game{}, atom(), coords(), coords()) :: {atom(), %Game{}}
  def validate(game, player, from, to) do
    {:ok, game}
    |> check_valid_coord(from)
    |> check_valid_coord(to)
    |> check_same_location(from, to)
    |> check_piece_exists(from)
    |> check_right_piece(player, from)
    |> check_valid_move(from, to)
    |> check_occupied(to)
    |> check_valid_hop(player, from, to)
  end


  @spec check_valid_coord({atom(), %Game{}} | %Game{}, coords()) :: {atom(), %Game{}}
  def check_valid_coord({:ok, game}, %{row: row, col: col}) do
    status = case Board.get_cell(game.board, row, col) do
      {:ok, _cell} -> :ok
      {:error, _reason} -> :invalid_coord
    end

    {status, game}
  end

  def check_valid_coord({status, game}, _coord) do
    {status, game}
  end

  @spec check_piece_exists({atom(), %Game{}}, coords()) :: {atom(), %Game{}}
  def check_piece_exists({:ok, game}, %{row: row, col: col}) do
    status = case Board.get_cell(game.board, row, col) do
      {:ok, %Cell{occupier: nil}} -> :no_piece
      _ -> :ok
    end

    {status, game}
  end

  def check_piece_exists({status, game},_coords) do
    {status, game}
  end

  @spec check_right_piece({atom(), %Game{}}, player(), coords()) :: {atom(), any()}
  def check_right_piece({:ok, game}, player, %{row: row, col: col}) do
    {:ok, %Cell{occupier: occupier}} = Board.get_cell(game.board, row, col)

    status = case occupier === player do
      true -> :ok
      false -> :wrong_piece
    end

    {status, game}
  end

  def check_right_piece({status, game}, _player, _status) do
    {status, game}
  end

  @spec check_same_location({atom(), %Game{}}, coords(), coords()) :: {:ok, %Game{}} | {:same_location, %Game{}}
  def check_same_location({:ok, game}, from, to) do
    status = case Map.equal?(from, to) do
      false ->:ok
      true -> :same_location
    end

    {status, game}
  end

  def check_same_location({status, game}, _from, _to) do
    {status, game}
  end

  @spec check_valid_move({atom(), %Game{}}, coords(), coords()) :: {atom(), %Game{}}
  def check_valid_move({:ok, game}, %{row: row1, col: col1}, %{row: row2, col: col2}) do
    status = case {abs(col1 - col2), abs(row1 - row2)} do
      {1, 1} -> :ok
      {2, 2} -> :possible_hop
      _ -> :invalid_move
    end

    {status, game}
  end

  def check_valid_move({status, game}, _from, _to), do: {status, game}

  @spec check_occupied({atom(), %Game{}}, coords()) :: {atom(), %Game{}}
  def check_occupied({:ok, game}, %{row: row, col: col}) do
    status = case Board.get_cell(game.board, row, col) do
      {:ok, %Cell{occupier: nil}} -> :ok
      _ -> :blocked
    end

    {status, game}
  end

  def check_occupied({status, game}, _coords) do
    {status, game}
  end

  @spec check_valid_hop({atom(), %Game{}}, atom(), coords(), coords()) :: {atom(), %Game{}}
  def check_valid_hop({:possible_hop, game}, player, from, to) do
    %{row: row, col: col} = get_middle_coords(from, to)
    {_status, %Cell{occupier: occupier}} = Board.get_cell(game.board, row, col)

    status = case occupier do
      nil -> :invalid_hop
      occupier -> check_hopped_cell(player, occupier)
    end

    {status, game}
  end

  def check_valid_hop({status, game}, _player,  _from, _to), do: {status, game}

  @spec get_middle_coords(coords(), coords()) :: coords()
  def get_middle_coords(from, to) do
    case get_larger_row(from, to) do
      %{row: same, col: same} -> %{row: same-1, col: same-1}
      %{row: row, col: col}   -> %{row: row-1, col: col+1}
    end
  end

  @spec get_larger_row(coords(), coords()) :: coords()
  def get_larger_row(cell1 = %{row: row1}, cell2 = %{row: row2}) do
    case row1 > row2 do
      true -> cell1
      false -> cell2
    end
  end

  @spec check_hopped_cell(atom(), atom()) :: :hop | :invalid_hop
  def check_hopped_cell(player, player),      do: :invalid_hop
  def check_hopped_cell(_player, _opponent),  do: :hop
end
