defmodule GameManager do
  defdelegate create_game(),                to: GameManager.GamesSupervisor
  defdelegate move(pid, player, from, to),  to: GameManager.Games
end
