defmodule Game.Util do
  @spec get_opponent(:black | :white) :: :black | :white
  def get_opponent(:white), do: :black
  def get_opponent(:black), do: :white
end
