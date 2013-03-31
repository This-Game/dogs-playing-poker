DogsPlayingPoker = module.exports = {}
{Card} = require 'coffee/card.coffee'
{Deck} = require 'coffee/deck.coffee'
{Dog} = require 'coffee/dog.coffee'

for classOfDog in Dog.all
  dog = new classOfDog
  deck = new Deck

  hand = deck.take 5
  console.log "The #{dog.name()} reads its hand:"
  dog.read hand
  console.log('--------------')
  console.log()