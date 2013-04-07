{Card} = require 'coffee/card.coffee'
{Deck} = require 'coffee/deck.coffee'
{Dog} =  require 'coffee/dog.coffee'
{Util} =  require 'coffee/util.coffee'
_ = require "underscore"

Game =
  players: {}

  deck: new Deck

  addPlayer: (player) ->
    unless @possiblyFindPlayer(player.id)
      dealtCards = @deck.take 5
      player = Dog.newByType(player, dealtCards)
      console.log "Added player #{player.name} :: #{player.id}", player.hand
      @players[player.id] = player
      player

  findPlayer: (id) ->
    player = @possiblyFindPlayer(id)
    throw "No player found with id '#{id}'" unless player
    player

  findPlayers: (playerIds...) ->
    (@findPlayer id for id in playerIds)

  possiblyFindPlayer: (id) ->
    @players[id]

  removePlayer: (id) ->
    console.log "Removing Player #{id}"
    player = @possiblyFindPlayer id
    delete @players[player.id]

  exchange: (player, cardsIdsToExchange) ->
    decryptedCards = (Card.reconstitute(id) for id in cardsIdsToExchange)
    console.log "Returning cards: #{decryptedCards}"
    # Remove return cards from the player's hand
    newHand = _.reject player.hand, (card) -> card.id in cardsIdsToExchange
    console.log "HAND with card removed", newHand
    # Push returned cards onto the bottom of the deck.
    @deck.push card for card in decryptedCards
    # Deal new cards to the player
    dealtCards = @deck.take(cardsIdsToExchange.length)
    console.log "HAND with new cards", newHand.concat(dealtCards)
    player.setHand newHand.concat(dealtCards)

exports.Game = Game