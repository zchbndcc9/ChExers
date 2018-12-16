defmodule Player do
  defdelegate determine_move(), to: Player.Move
end
