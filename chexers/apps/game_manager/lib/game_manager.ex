defmodule GameManager do
  defdelegate create_game(),                      to: GameManager.GamesSupervisor
  defdelegate delete_game(name),                  to: GameManager.GamesSupervisor
  defdelegate move(game_name, player, from, to),  to: GameManager.Games
  defdelegate get_game(name),                     to: GameManager.Games
end
