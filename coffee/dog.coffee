_ = require 'underscore'
{Card} = require 'coffee/card.coffee'

class Dog
  constructor: (playerData) ->
    @name = playerData.name
    @kindOfDog = playerData.kindOfDog
    @hand = cards: playerData.cards
    @perspectivalHand = cards: @read(playerData.cards)

  name: (handOfCards) ->
    @constructor.name

  read: (cards) ->
    @valueFor card for card in cards

  valueFor: (card) ->
    throw "Plz implement this on your own damn dog"


# Collies know numbers and letters, i.e. anything but face cards
class Collie extends Dog
  valueFor: (card) ->
    rank = if card.isFaceCard()
      "Person"
    else
      card.value
    new Card "blobs", rank

# Greyhounds can recognize Faces and Aces
class Greyhound extends Dog
  valueFor: (card) ->
    rank = if card.isFaceCard() or card.isAce()
      card.rank
    else
      "Number"
    new Card rank, "blobs"

# Pugs can see COLOR
# They can tell numbers and colors apart, but can't be more specific than that.
class Pug extends Dog
  valueFor: (card) ->
    rank = if card.isFaceCard() then "Person" else "Number"
    new Card rank, card.color()

# Pugs can make out shapes; i.e. they know suits
class Corgi extends Dog
  valueFor: (card) ->
    new Card "?", card.suit

Dog.byName = "Collie": Collie, "Greyhound": Greyhound, "Pug": Pug, "Corgi": Corgi
exports.Dog = Dog
