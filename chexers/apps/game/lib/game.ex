defmodule Game do
  alias Game.Board
  alias Game.Board.Cell

  use TypedStruct

  typedstruct do
    field :board, list(Cell)
    field :white_pieces, non_neg_integer, default: 12
    field :black_pieces, non_neg_integer, default: 12
    field :winner, :white | :black | nil, default: nil
    field :current_turn, :white | :black | nil, default: nil
  end

  def create() do
    board = Board.create()
    |> initialize()

    %Game{ board: board }
  end

  defp initialize(board) do
    board = board
    |> Enum.chunk_by(fn %Cell{row: row} -> row end)

    white_placement = Task.async(fn -> place_player_pieces(board, 0, 3, :white) end)
    rest = Enum.slice(board, 3, 2)
    black_placement = Task.async(fn -> place_player_pieces(board, 5, 3, :black) end)

    new_board = [Task.await(white_placement) | Task.await(black_placement)]
    new_board = [rest | new_board] |> List.flatten()

    new_board 
  end

  defp place_player_pieces(board, start, count, piece) do
    board
    |> Enum.slice(start, count)
    |> Enum.map(fn row -> Task.async(fn -> place_row_pieces(row, piece) end) end)
    |> Enum.map(fn task -> Task.await(task) end)
  end

  defp place_row_pieces(row, piece) do
    row
    |> Enum.map(fn cell -> place_piece(cell, piece) end)
  end

  defp place_piece(cell = %Cell{movable?: false}, _piece) do
    cell
  end

  defp place_piece(cell = %Cell{}, piece) do
    %Cell{cell | occupier: piece}
  end
end
