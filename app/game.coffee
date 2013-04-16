_ = require "underscore"
{Card} = require './card.coffee'
{Deck} = require './deck.coffee'
{Dog}  = require './dog.coffee'
{Util} = require './util.coffee'

class Game

  constructor: ->
    @players = {}
    @communityCards = []
    @deck = new Deck

  addPlayer: (player) ->
    console.log "Adding player:", player, @possiblyFindPlayer(player.id)
    unless @possiblyFindPlayer(player.id)
      player = Dog.newByType(player)
      @players[player.id] = player
      player

  dealCommunityCards: (number) ->
    @communityCards = @communityCards.concat @deck.take(number)

  dealToPlayers: (number) ->
    for player in _(@players).values()
      cards = @deck.take(number)
      player.setHand player.hand.concat(cards)

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