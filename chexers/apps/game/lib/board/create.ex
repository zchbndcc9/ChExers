defmodule Game.Board.Create do
  alias Board.Cell
  # Macro used in order to secure board creation function while keeping the
  # guard nice and concise.
  defmacro is_valid_size(size) do
    quote do
      is_integer(unquote(size)) and unquote(size) > 0
    end
  end
  @spec create() :: {:ok, list(Cell)} | {:error, String}
  def create(size \\ 8) when is_integer(size) do
    board =
      0..size-1
      |> Enum.map(fn row -> Task.async(fn -> create_row([], row, size-1) end) end)
      |> Enum.map(fn task -> Task.await(task) end)
      |> List.flatten
      |> initialize()

    {:ok, board}
  end

  def create(_) do
    {:error, "Must supply a positive integer for size"}
  end

  defp create_row(cells, _row, -1) do
    cells
  end

  defp create_row(cells, row, col) do
    [%Cell{row: row, col: col, movable?: movable?(row, col)} | cells]
    |> create_row(row, col-1)
  end

  defp movable?(row, col) do
    case {rem(row, 2), rem(col, 2)} do
      {same, same} -> true
      {_, _} -> false
    end
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
