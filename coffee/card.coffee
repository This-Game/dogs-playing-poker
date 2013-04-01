class Card
  constructor: (@rank, @suit) ->

  value: ->
    switch @rank
      when "A" then 14
      when "K" then 13
      when "Q" then 12
      when "J" then 11
      else @rank

  isAce: ->
    @rank is 'A'

  isFaceCard: ->
    @value > 10 and @value < 14

  isRed: ->
    @suit in ["Diamonds", "Hearts"]

  toString: ->
    "#{@rankName} of #{@suit}"

  rankName: ->
    switch @rank
      when "A" then "Ace"
      when "K" then "K"
      when "Q" then "Queen"
      when "J" then "Jack"
      else @rank

  suitSymbol: ->
    switch @suit
      when "Diamonds" then '&diams;'
      when "Hearts" then '&hearts;'
      when "Spades" then '&spades;'
      when "Clubs" then '&clubs;'

  suitClass: ->
    @suit.toLowerCase()

exports.Card = Card
