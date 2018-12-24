defmodule ServerWeb.GameController do
  use ServerWeb, :controller

  def create(conn, _params) do
    {_status, game_name} = GameManager.create_game()

    conn
    |> render(ServerWeb.GameView, "name.json", %{"name" => game_name})
  end

  def show(conn, %{"id" => game_id}) do
    {status, body} =
      case GameManager.get_game(game_id) do
        {:ok, game} -> {200, game}
        {:error, _} -> {400, "No game"}
      end

      case status do
        400 ->
          conn
          |> send_resp(400, body)
        200 ->
          conn
          |> render(ServerWeb.GameView, "show.json", %{"game" => body})
      end
  end

  def delete(conn, %{"id" => game_id}) do
    {_status, _message} = GameManager.delete_game(game_id)

    conn
    |> send_resp(200, "Game deleted")
  end
end
