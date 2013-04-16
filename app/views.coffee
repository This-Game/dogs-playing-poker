Hogan = require 'hogan.js'
fs = require 'fs'

readTemplateFile = (templateName) ->
  fs.readFileSync(__dirname + "/../views/#{templateName}.mustache",  'utf8')

exports.Views =
  cards:
    Hogan.compile(readTemplateFile 'cards')

  playerList:
    Hogan.compile(readTemplateFile 'player-list')

  revealedCards:
    Hogan.compile(readTemplateFile 'revealed-cards')

  dealer:
    Hogan.compile(readTemplateFile 'dealer')

  dealerPlayerList:
    Hogan.compile(readTemplateFile 'dealer-player-list')

  confirmCardReveal:
    Hogan.compile(readTemplateFile 'confirm-card-reveal')

Hogan.partials