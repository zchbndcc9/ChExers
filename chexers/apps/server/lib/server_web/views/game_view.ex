defmodule ServerWeb.GameView do
  use ServerWeb, :view
  def render("show.json", %{"game" => game}) do
    %{
      board: Enum.map(game.board, fn cell -> ServerWeb.CellView.render("show.json", %{"cell" => cell}) end),
      game_pieces: %{white: game.game_pieces.white, black: game.game_pieces.black},
      winner: game.winner,
      game_status: game.game_status,
      current_turn: game.current_turn
    }
  end
end
