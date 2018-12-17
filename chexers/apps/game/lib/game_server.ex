defmodule Game.Server do
  use GenServer

  def start_link(user_id) do
    GenServer.start_link(@me, user_id)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end
end
