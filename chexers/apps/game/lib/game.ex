defmodule Game do
  alias Game.Board
  alias Game.Board.Cell
  alias Game.Move.Validator

  use TypedStruct

  @type coords :: %{ row: integer, col: integer }

  typedstruct do
    field :board, list(Cell)
    field :white_pieces, non_neg_integer, default: 12
    field :black_pieces, non_neg_integer, default: 12
    field :winner, :white | :black | nil, default: nil
    field :game_status, atom(), default: :initializing
    field :current_turn, :white | :black | nil, default: nil
  end

  def new_game() do
    board =
      Board.create()
      |> (fn {:ok, board} -> initialize(board) end).()

    {:ok, %Game{ board: board }}
  end

  # Guard to ensure that game is not altered once it has already been won
  @spec move(Game.t(), atom(), coords(), coords()) :: {atom(), Game.t()}
  def move(game = %Game{game_status: :won}, _player, _from, _to) do
    {:ok, game}
  end

  def move(game = %Game{}, player, from, to) do
    {status, game} =
      game
      |> Validator.validate(player, from, to)
      |> move_piece(player, from, to)
      |> update_game()
      |> determine_game_status()

    {status, game}
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

  defp move_piece({:ok, game}, player, from, to) do
    # EXTRACT TO OWN FXN
    from_cell_task = Task.async(fn -> Enum.find(game.board, fn cell -> cell.row === from.row and cell.col === from.col end) end)
    to_cell_task = Task.async(fn -> Enum.find(game.board, fn cell -> cell.row === to.row and cell.col === to.col end) end)
    filter_board_task = Task.async(fn ->
      game.board
      |> Enum.reject(fn cell -> cell.row === to.row and cell.col === to.col end)
      |> Enum.reject(fn cell -> cell.row === to.row and cell.col === to.col end)
    end)

    from_cell = Task.await(from_cell_task)
    to_cell = Task.await(to_cell_task)
    filtered_board = Task.await(filter_board_task)

    new_board =
      [%Cell{ from_cell | occupier: nil} | [%Cell{to_cell | occupier: player} | filtered_board]]
      |> List.flatten

    {:ok, %Game{game | board: new_board}}
  end

  defp move_piece({:hop, game}, player, from, to) do
    # DO WORK TO MOVE PIECE and alter game
    from_cell_task = Task.async(fn -> Enum.find(game.board, fn cell -> Map.equal?(cell, from) end) end)
    to_cell_task = Task.async(fn -> Enum.find(game.board, fn cell -> Map.equal?(cell, to) end) end)
    filter_board_task = Task.async(fn ->
      game.board
      |> Enum.reject(fn cell -> Map.equal?(cell, from) end)
      |> Enum.reject(fn cell -> Map.equal?(cell, to) end)
    end)

    from_cell = Task.await(from_cell_task)
    to_cell = Task.await(to_cell_task)
    filtered_board = Task.await(filter_board_task)

    opponent = get_opponent(player)

    {:ok, game}
  end

  defp move_piece({status, game}, _player, _from, _to), do: {status, game}

  defp get_opponent(:white), do: :black
  defp get_opponent(:black), do: :white

  defp update_game({:ok, game}) do
    {:ok, game}
  end

  defp update_game({status, game}), do: {status, game}


  # I was torn on whether to pattern match or use cases, but I went with the
  # latter since I think it leads to clean, more concise code
  defp determine_game_status({status, game}) do
    game = case game do
      %Game{ white_pieces: 0 } -> %Game{ game | winner: :black, game_status: :won }
      %Game{ black_pieces: 0 } -> %Game{ game | winner: :white, game_status: :won }
      _ -> %Game{ game | game_status: :in_progress}
    end

    {status, game}
  end
end
