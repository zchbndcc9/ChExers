defmodule GameMatcher do
  defdelegate put_in_room(player, game_name),   to: GameMatcher.WaitingRoom
  defdelegate game_exists?(game_name),          to: GameMatcher.WaitingRoom
  # # defdelegate match_player(player, game_name),  to: GameMatcher.Matcher
end
