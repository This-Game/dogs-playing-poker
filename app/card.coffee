{Util} = require './util.coffee'

class Card
  constructor: (@rank, @suit, @id) ->
    @id = Util.encrypt "#{@rank},#{suit}" unless @id

  @reconstitute: (cardId) ->
    [rank, suit] = Util.decrypt(cardId).split(',')
    new Card rank, suit, cardId

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

  color: ->
    if @suit in ["Diamonds", "Hearts"] then "Red" else "Black"

  toString: ->
    "<CARD: #{@rankName()} of #{@suit}>"

  rankName: ->
    switch @rank
      when "A" then "Ace"
      when "K" then "K"
      when "Q" then "Queen"
      when "J" then "Jack"
      when "Number" then "٢"
      else @rank

  suitSymbol: ->
    switch @suit
      when "Diamonds" then '&diams;'
      when "Hearts" then '&hearts;'
      when "Spades" then '&spades;'
      when "Clubs" then '&clubs;'
      else @randomSuitSymbol()

  suitClass: ->
    @suit.toLowerCase()

  randomSuitSymbol: ->
    "❈"

# symbols =[
#   "&#10021;",
#   "&#10083;",
#   "&#10087;",
#   "&#9877;",
#   "&#41402;",
#   "&#3572;",
#   "&#9876;",
#   "&#164;",
#   "&#9800;",
#   "&#9733;",
#   "&#10047;",
#   "&#10056;",
#   "&#9096;",
#   "&#9798;"
# ]
# symbols[Math.floor(Math.random() * symbols.length)]

# king and queen:
# &#9819;
# &#9812;

exports.Card = Card
