defmodule Game.Board.Move do
  alias Game.Board.Cell

  def move(board, player, from, to) do
    from_cell_task = Task.async(fn -> Enum.find(board, fn cell -> cell.row === from.row and cell.col === from.col end) end)
    to_cell_task = Task.async(fn -> Enum.find(board, fn cell -> cell.row === to.row and cell.col === to.col end) end)
    filter_board_task = Task.async(fn ->
      board
      |> Enum.reject(fn cell -> cell.row === from.row and cell.col === from.col end)
      |> Enum.reject(fn cell -> cell.row === to.row and cell.col === to.col end)
    end)

    from_cell = Task.await(from_cell_task)
    to_cell = Task.await(to_cell_task)
    filtered_board = Task.await(filter_board_task)

    [%Cell{ from_cell | occupier: nil} | [%Cell{to_cell | occupier: player} | filtered_board]]
    |> List.flatten
  end

  def remove(board, piece_to_remove) do
    board
      |> Enum.reject(fn cell -> Map.equal?(cell, piece_to_remove) end)
      |> (fn board -> [%Cell{piece_to_remove | occupier: nil} | board] end).()
  end
end
