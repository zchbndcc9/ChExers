defmodule Game.Board.Draw do
  alias Game.Board.Cell

  def draw(board) do
    IO.puts("     0   1   2   3   4   5   6   7")
    board
    |> Enum.sort(fn c1, c2 -> c1.row < c2.row end)
    # Find a way to conditionally draw based on size
    |> Enum.chunk_every(8)
    |> Enum.map(fn row -> Enum.sort(row, fn c1, c2 -> c1.col < c2.col end) end)
    |> draw_rows(0)

    IO.puts "   --------------------------------"
  end


  defp draw_rows([], _num), do: nil

  defp draw_rows([row | rows], num) do
    IO.puts "   --------------------------------"
    IO.write "#{num}  "
    Enum.each(row, fn cell -> draw_cell(cell) end)
    IO.write "|"
    IO.puts ""
    draw_rows(rows, num+1)
  end

  defp draw_cell(%Cell{occupier: :white, movable?: true}) do
    IO.write "|"
    Printex.color_print " O" , :white_on_light_white
  end

  defp draw_cell(%Cell{occupier: :white, movable?: false}) do
    IO.write "|"
    Printex.color_print " O ", :white_on_light_blue
  end

  defp draw_cell(%Cell{occupier: :black, movable?: true}) do
    IO.write "|"
    Printex.color_print " 0 ", :black_on_light_white
  end

  defp draw_cell(%Cell{occupier: :black, movable?: false}) do
    IO.write "|"
    Printex.color_print " 0 ", :black_on_light_blue
  end

end
