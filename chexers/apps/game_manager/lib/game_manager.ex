defmodule GameManager do
  defdelegate create_game(),                to: GameManager.GamesSupervisor
  defdelegate delete_game(name),            to: GaManager.GamesSupervisor
  defdelegate move(game_name, player, from, to),  to: GameManager.Games
end
