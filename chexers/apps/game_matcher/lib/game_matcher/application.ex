defmodule GameMatcher.Application do
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {GameMatcher.WaitingRoom, []}
      # {GameMatcher.Matcher, nil}      # {GameMatcher.Worker, arg},
    ]
    opts = [strategy: :one_for_one, name: GameMatcher.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
