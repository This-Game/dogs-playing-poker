

# Corgis can make out shapes; i.e. they know suits
class Corgi extends Dog
  value_for: (card) ->
    "Something of #{card.suit}"