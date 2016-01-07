#!/usr/bin/env ruby
require "steam-api"
require 'json'

currentId = Steam::User.vanity_to_steamid("fabienfoerster")
params = {"include_appinfo" => 1}
currentUserGames = Steam::Player.owned_games(currentId, params: params)

games =  currentUserGames['games'].map { |g| g['name'] }




friendsids = Steam::User.friends(currentId, relationship: :friend).map { |f| f['steamid']  }


friends = Steam::User.summaries(friendsids)
friends = friends.map { |f| {f['personaname'] => f['steamid'] } }

friendId = 76561198109436762

friendGames = Steam::Player.owned_games(friendId, params: params)
friendGames = friendGames['games'].map { |g| g['name']  }



diff = games - friendGames
diff = games - diff
puts diff
