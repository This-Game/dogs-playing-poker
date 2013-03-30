class Card
  constructor: (@rank, @suit) ->

  value: ->
    switch day
      when "Ace" then 14
      when "King" then 13
      when "Queen" then 12
      when "Jack" then 11
      else @rank

  isAce: ->
    @rank is 'Ace'

  isFaceCard: ->
    @value > 10 and @value < 14

  isRed: ->
    @suit in ["Diamonds", "Hearts"]

  toString: ->
    "#{@rank} of #{@suit}"

exports.Card = Card
