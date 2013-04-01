{Card} = require 'coffee/card.coffee'
{Deck} = require 'coffee/deck.coffee'
{Dog} =  require 'coffee/dog.coffee'

Game =
  players: {}

  deck: new Deck
  addPlayer: (player) ->
    unless Game.players[player.name]
      KindOfDog = Dog.byName[player.kindOfDog]
      player.dog = new KindOfDog
      player.hand = {cards: Game.deck.take 5}
      Game.players[player.name] = player

exports.Game = Game