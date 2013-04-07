Hogan = require 'hogan.js'
fs = require 'fs'

readTemplateFile = (templateName) ->
  fs.readFileSync(__dirname + "/views/#{templateName}.mustache",  'utf8')

exports.MustacheViews =
  hand:
    Hogan.compile(readTemplateFile 'hand')

  playerList:
    Hogan.compile(readTemplateFile 'player-list')

  revealedCards:
    Hogan.compile(readTemplateFile 'revealed-cards')