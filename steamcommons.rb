#!/usr/bin/env ruby
require "steam-api"
require 'highline'

cli = HighLine.new

vanityName = cli.ask "What is your vanity name ?"

currentId = Steam::User.vanity_to_steamid(vanityName)
params = {"include_appinfo" => 1}
currentUserGames = Steam::Player.owned_games(currentId, params: params)

games =  currentUserGames['games'].map { |g| g['name'] }


friendsids = Steam::User.friends(currentId, relationship: :friend).map { |f| f['steamid']  }


friends = Steam::User.summaries(friendsids)
friends = friends.map { |f| [f['personaname'], f['steamid'] ] }.flatten
hashFriends = Hash[*friends]
friendId = 0
cli.choose do |menu|
  menu.prompt = "Who do you want to know games in common with ?  "
  hashFriends.keys.each { |f|
    menu.choice(f) {
      friendId = hashFriends[f]
      cli.say("These are the games in commons between you and #{f} \n\n")
    }
  }
end

friendGames = Steam::Player.owned_games(friendId, params: params)
friendGames = friendGames['games'].map { |g| g['name']  }



diff = games - friendGames
diff = games - diff
puts diff
