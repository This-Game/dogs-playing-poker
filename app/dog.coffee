{Card} = require './card.coffee'
{Util} = require './util.coffee'

class Dog
  constructor: (playerData, cards = []) ->
    @id ?= Util.makeGUID()
    @name = playerData.name
    @kindOfDog = playerData.kindOfDog
    @setHand cards if cards

  @newByType: (playerData, cards) ->
    DogType = @byName[playerData.kindOfDog]
    new DogType(playerData, cards)

  name: ->
    @constructor.name

  perspectivalHand: (aHand) ->
    @read aHand or @hand

  read: (cards) ->
    @valueFor card for card in cards

  valueFor: (card) ->
    if card instanceof Card
      card
    else
      throw "Hot holy cold mold, #{card.constructor.name} isn't a card.\n #{card}"

  setHand: (cards) ->
    console.log "Setting hand", @name, cards
    @hand = cards

  showCards: (cardIds, otherPlayer) ->
    cards = (Card.reconstitute id for id in cardIds)
    showingPlayer:
      cards: this.read(cards)
    shownPlayer:
      cards: otherPlayer.read(cards)

# Collies know numbers
class Collie extends Dog
  valueFor: (card) ->
    super(card)
    rank = if card.isFaceCard()
      "Person"
    else
      card.value()
    new Card rank, "blobs", card.id

# Greyhounds can recognize Faces and Aces
class Greyhound extends Dog
  valueFor: (card) ->
    super(card)
    rank = if card.isFaceCard() or card.isAce()
      card.rank
    else
      "0"
    new Card rank, "blobs", card.id

# Pugs can see COLOR
# They can also tell numbers and people apart, but that's as specific as it gets.
class Pug extends Dog
  valueFor: (card) ->
    super(card)
    rank = if card.isFaceCard() then "High Card" else "Number"
    new Card rank, card.color(), card.id

# Corgis can make out shapes; i.e. they know suits
class Corgi extends Dog
  valueFor: (card) ->
    super(card)
    new Card "?", card.suit, card.id

# Humans are a highly advanced form of dogg
class Human extends Dog
  valueFor: (card) ->
    super(card)

Dog.byName = "Collie": Collie, "Greyhound": Greyhound, "Pug": Pug, "Corgi": Corgi, "Human": Human
exports.Dog = Dog
