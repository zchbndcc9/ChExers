defmodule ServerWeb.GameChannel do
  use Phoenix.Channel

  def join("game" <> game_id, _payload, socket) do
    {:ok, socket}
  end

  def handle_in("message", message, socket) do
    broadcast! socket ,"message", %{body: message}
    {:noreply, socket}
  end
end
