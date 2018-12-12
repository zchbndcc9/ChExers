defmodule Game do
  alias Game.Board
  alias Game.Board.Cell

  use TypedStruct

  @type coords :: %{ row: integer, col: integer }

  typedstruct do
    field :board, list(Cell)
    field :white_pieces, non_neg_integer, default: 12
    field :black_pieces, non_neg_integer, default: 12
    field :winner, :white | :black | nil, default: nil
    field :status, atom(), default: :initializing
    field :current_turn, :white | :black | nil, default: nil
  end

  def new_game() do
    board = Board.create() |> initialize()

    %Game{ board: board }
  end

  # Guard to ensure that game is not altered once it has already been won
  @spec move(Game.t(), atom(), coords(), coords()) :: Game.t()
  def move(game = %Game{status: :won}, _player, _from, _to) do
    game
  end

  def move(game = %Game{}, player, from, to) do
    game
    |> check_valid_move(from, to)
    |> move_piece(player, from, to)
    |> update_game()
    |> determine_game_status()
  end

  ## Helpers

  # Adds player pieces to board asynchronously
  # Plan on consolidating and cleaning in the near future
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

    defp check_valid_move(game, from, to) do
    case Map.equal?(from, to) do
      false -> %Game{ game | status: :invalid_move }
      true -> game
    end
  end

  defp move_piece(game = %Game{ status: :invalid_move }, _player, _from, _to) do
    game
  end

  defp move_piece(game, player, from, to) do
    game
  end

  defp update_game(game) do
    
  end

  # I was torn on whether to pattern match or use cases, but I went with the
  # latter since I think it leads to clean, more concise code
  defp determine_game_status(game) do
    case game do
      %Game{ white_pieces: 0 } -> %Game{ game | winner: :black, status: :won }
      %Game{ black_pieces: 0 } -> %Game{ game | winner: :white, status: :won }
      _ -> game
    end
  end

end
