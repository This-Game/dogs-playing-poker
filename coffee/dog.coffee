{Card} = require 'coffee/card.coffee'
{Util} = require 'coffee/util.coffee'

class Dog
  constructor: (playerData, cards) ->
    @id ?= Util.makeGUID()
    @name = playerData.name
    @kindOfDog = playerData.kindOfDog
    @setHand cards if cards

  @newByType: (playerData, cards) ->
    DogType = @byName[playerData.kindOfDog]
    new DogType(playerData, cards)

  name: (handOfCards) ->
    @constructor.name

  perspectivalHand: (aHand) ->
    console.log "aHand", aHand
    console.log "hand", @hand
    @read aHand or @hand

  read: (cards) ->
    @valueFor card for card in cards

  valueFor: (card) ->
    unless card instanceof Card
      throw "Hot holy cold mold, can't read this #{card.constructor.name} isn't a card.\n #{card}"
    card

  setHand: (cards) ->
    console.log "Setting hand", cards
    @hand = cards

# Collies know numbers and letters, i.e. anything but face cards
class Collie extends Dog
  valueFor: (card) ->
    super(card)
    rank = if card.isFaceCard()
      "Person"
    else
      card.value
    new Card rank, "blobs", card.id

# Greyhounds can recognize Faces and Aces
class Greyhound extends Dog
  valueFor: (card) ->
    super(card)
    rank = if card.isFaceCard() or card.isAce()
      card.rank
    else
      "Number"
    new Card rank, "blobs", card.id

# Pugs can see COLOR
# They can tell numbers and colors apart, but can't be more specific than that.
class Pug extends Dog
  valueFor: (card) ->
    super(card)
    console.log card
    console.log card.suit
    console.log card.rankName
    rank = if card.isFaceCard() then "Person" else "Number"
    new Card rank, card.color(), card.id

# Pugs can make out shapes; i.e. they know suits
class Corgi extends Dog
  valueFor: (card) ->
    super(card)
    new Card "?", card.suit, card.id

# Humans are a highly advanced kind of dog
class Human extends Dog
  valueFor: (card) ->
    super(card)

Dog.byName = "Collie": Collie, "Greyhound": Greyhound, "Pug": Pug, "Corgi": Corgi, "Human": Human
exports.Dog = Dog
