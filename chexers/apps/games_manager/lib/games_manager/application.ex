defmodule GamesManager.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, name: GamesManager.Supervisor}
    ]

    opts = [strategy: :one_for_one, name: GamesManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
