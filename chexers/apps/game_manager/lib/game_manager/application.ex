defmodule GameManager.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: :game_registry},
      {DynamicSupervisor, strategy: :one_for_one, name: GameManager.GamesSupervisor}
    ]

    opts = [strategy: :one_for_one, name: GameManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
