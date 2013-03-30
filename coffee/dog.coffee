class Dog
  name: ->
    @constructor.name

  read: (cards) ->
    console.log @value_for card for card in cards

  value_for: (card) ->
    throw "Plz implement this on your own damn dog"

# Collies know numbers and letters, i.e. anything but face cards
class Collie extends Dog
  value_for: (card) ->
    val = if card.isFaceCard()
      "Person"
    else
      card.value
    "#{val} of blobs"

# Greyhounds can recognize Faces and Aces
class Greyhound extends Dog
  value_for: (card) ->
    val = if card.isFaceCard() or card.isAce()
      card.rank
    else
      "Some number"
    "#{val} of blobs"

# Pugs can see COLOR
# They can tell numbers and colors apart, but can't be more specific than that.
class Pug extends Dog
  value_for: (card) ->
    color = if card.isRed() then 'Red' else 'Black'
    rank = if card.isFaceCard() then "Person" else "Number"
    "#{rank} of #{color}"

# Pugs can make out shapes; i.e. they know suits
class Corgi extends Dog
  value_for: (card) ->
    "Something of #{card.suit}"

Dog.all = [Collie, Greyhound, Pug, Corgi]
exports.Dog = Dog
