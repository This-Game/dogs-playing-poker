http = require 'http'
_ = require 'underscore'
io = require "socket.io"
express = require "express"

{MustacheViews} = require 'views.coffee'
{Game} = require 'game.coffee'
{Deck} = require 'coffee/deck.coffee'

app = express()
server = http.createServer(app)
app.configure ->
  app.use express.static(__dirname + '/public')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.set 'view engine', 'hogan.js'
  app.set 'view options', {layout:false}
  app.set 'views', __dirname + '/views'

ioServer = io.listen(server)
server.listen 2222

gameChannel = ioServer.of '/game.prototype'

gameChannel.on "connection", (socket) ->
  console.log "Connecting to #{socket}"
  socket.emit "updatedPlayersList", Game.players

  socket.on "playerRejoined", (playerId) ->
    console.log "BAY BAY BAY", playerId, Game.possiblyFindPlayer(playerId)
    if player = Game.possiblyFindPlayer(playerId)
      gameChannel.emit "updatedPlayersList", Game.players
      socket.emit "playerJoined", player.id
      socket.emit "updatedHand", MustacheViews.hand.render(cards: player.perspectivalHand())
    else
      socket.emit "playerLeft", playerId

  socket.on "addPlayer", (playerData) ->
    player = Game.addPlayer(playerData)
    gameChannel.emit "updatedPlayersList", Game.players
    gameChannel.emit "updatedDeck", deckSize: Game.deck.size()
    socket.emit "playerJoined", player.id
    socket.emit "updatedHand", MustacheViews.hand.render(cards: player.perspectivalHand())

  socket.on "exchangeCards", (playerId, cardIds) ->
    player = Game.findPlayer(playerId)
    console.log "#!!!!! #{playerId} wants to exchange cards", player.hand
    Game.exchange player, cardIds
    console.log "#!!!!! #{playerId} exchange is complete. #{cardIds}", player.hand

    gameChannel.emit "updatedDeck", deckSize: Game.deck.size(), playerId: player.id
    socket.emit "updatedHand", MustacheViews.hand.render(cards: player.perspectivalHand())

  socket.on "leaveGame", (playerId) ->
    Game.removePlayer(playerId)
    gameChannel.emit "updatedPlayersList", Game.players
    socket.emit "playerLeft", playerName

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')
