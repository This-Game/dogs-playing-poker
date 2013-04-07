{Card} = require './card.coffee'
{Util} = require './util.coffee'

class Deck
  constructor: ->
    throw "Make your own damn card deck!"

  # the Fisher-Yates shuffle
  shuffle: ->
    for element in [@cards.length-1..1]
      # Choose random element `j`
      randomElement = Math.floor Math.random() * (element + 1)
      # Swap `j` with `i`, using destructured assignment
      [@cards[element], @cards[randomElement]] = [@cards[randomElement], @cards[element]]
    @cards

  size: ->
    @cards.length

  take: (number) ->
    @cards.splice 0, number

  push: (cards) ->
    @cards = @cards.concat(cards)

class PokerDeck extends Deck
  constructor: ->
    @cards = []
    for rank in [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
      for suit in ['Spades', 'Hearts', 'Diamonds', 'Clubs']
        @cards.push(new Card rank, suit)
    @shuffle()

exports.Deck = PokerDeck
