Hogan = require 'hogan.js'
fs = require 'fs'

readTemplateFile = (templateName) ->
  fs.readFileSync(__dirname + "/../views/#{templateName}.mustache",  'utf8')

exports.Views =
  hand:
    Hogan.compile(readTemplateFile 'hand')

  playerList:
    Hogan.compile(readTemplateFile 'player-list')

  revealedCards:
    Hogan.compile(readTemplateFile 'revealed-cards')

  dealer:
    Hogan.compile(readTemplateFile 'dealer',
      hand: @hand,
      playerList: @playerList
    )

Hogan.partials