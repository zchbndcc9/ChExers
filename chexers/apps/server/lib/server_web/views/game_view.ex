defmodule ServerWeb.GameView do
  use ServerWeb, :view

  def render("show.json", %{"game" => game}) do
    %{
      board: game.board
        |> Enum.sort(&(&1.row < &2.row))
        |> Enum.chunk_every(8)
        |> Enum.map(fn row -> Task.async(fn -> Enum.sort(row, &(&1.col < &2.col)) end) end)
        |> Enum.map(fn task -> Task.await(task) end)
        |> List.flatten
        |> Enum.map(fn cell -> ServerWeb.PieceView.render("show.json", %{"piece" => cell}) end),
      num_pieces: %{white: game.game_pieces.white, black: game.game_pieces.black},
      winner: game.winner,
      game_status: game.game_status,
      current_turn: game.current_turn
    }
  end

  def render("name.json", %{"name" => game_name}) do
    %{
      name: game_name
    }
  end
end
