defmodule Game.Board.Draw do

  def draw(board) do
    board
    |> Enum.sort(fn c1, c2 -> c1.row > c2.row end)
    # Find a way to conditionally draw based on size
    |> Enum.chunk_every(8)
    |> Enum.map(fn row -> Enum.sort(row, fn c1, c2 -> c1.col < c2.col end) end)
    |> Enum.each(fn row -> draw_row(row) end)

    IO.puts "--------------------------------"
  end

  defp draw_row(row) do
    IO.puts "--------------------------------"
    Enum.each(row, fn cell -> draw_cell(cell) end)
    IO.write "|"
    IO.puts ""
  end

  defp draw_cell(%Cell{occupier: :white}),  do: IO.write "| O "
  defp draw_cell(%Cell{occupier: :black}),  do: IO.write "| 0 "
  defp draw_cell(%Cell{occupier: nil}),     do: IO.write "|   "

end
