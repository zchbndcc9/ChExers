defmodule Game.Board do
  alias Game.Board.Cell

  defdelegate create(size \\ 8), to: Game.Board.Create
  defdelegate move(board, player, from, to), to: Game.Board.Move
  defdelegate remove(board, piece), to: Game.Board.Move
  defdelegate draw(board), to: Game.Board.Draw

  def equal?(board1, board2) do
    sort_board1 = Task.async(fn -> Enum.sort(board1, &(&1.row <= &2.row and &1.col <= &2.col)) end)
    sort_board2 = Task.async(fn -> Enum.sort(board2, &(&1.row <= &2.row and &1.col <= &2.col)) end)

    compare_boards(Task.await(sort_board1), Task.await(sort_board2))
  end

  defp compare_boards([], []), do: true
  defp compare_boards([h | t1], [h | t2]), do: compare_boards(t1, t2)
  defp compare_boards(_, _), do: false

  @spec get_cell(list(Cell), integer, integer) :: {:error, String.t()} | {:ok, %Cell{}}
  def get_cell(board, row, col) do
    board
    |> Enum.find(fn cell -> cell.row === row and cell.col === col end)
    |> format_return()
  end

  defp format_return(nil), do: {:error, "No cell at these coordinates"}
  defp format_return(cell), do: {:ok, cell}

  def get_hopped_cell(board, from, to) do
    %{row: row, col: col} = Game.Util.get_middle_coords(from, to)
    {_status, cell} = get_cell(board, row, col)

    cell
  end
end
