defmodule Game.Board do
  alias Game.Board.Cell

  # Macro used in order to secure board creation function while keeping the
  # guard nice and concise.
  defmacro is_valid_size(size) do
    quote do
      is_integer(unquote(size)) and unquote(size) > 0
    end
  end

  @spec create(integer()) :: {:ok, list(Cell)} | {:error, String}
  def create(size \\ 8)
  def create(size) when is_valid_size(size) do
    board =
      0..size-1
      |> Enum.map(fn row -> Task.async(fn -> create_row([], row, size-1) end) end)
      |> Enum.map(fn task -> Task.await(task) end)
      |> List.flatten
    {:ok, board}
  end

  def create(_) do
    {:error, "Must supply a positive integer for size"}
  end

  def equal?(board1, board2) do
    sort_board1 = Task.async(fn -> Enum.sort(board1, &(&1.row <= &2.row and &1.col <= &2.col)) end)
    sort_board2 = Task.async(fn -> Enum.sort(board2, &(&1.row <= &2.row and &1.col <= &2.col)) end)

    compare_boards(Task.await(sort_board1), Task.await(sort_board2))
  end

    defp compare_boards([], []), do: true
    defp compare_boards([h | t1], [h | t2]), do: compare_boards(t1, t2)
    defp compare_boards(_, _), do: false

  @spec get_cell(list(Cell), integer(), integer()) :: {any(), any()}
  def get_cell(board, row, col) do
    board
    |> Enum.find(fn cell -> cell.row === row and cell.col === col end)
    |> format_return()
  end

  def format_return(nil), do: {:error, "No cell at these coordinates"}
  def format_return(cell), do: {:ok, cell}

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
end
