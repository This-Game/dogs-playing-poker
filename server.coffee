http = require 'http'
_ = require 'underscore'
io = require 'socket.io'
express = require 'express'

{Game}  = require './app/game.coffee'
{Views} = require './app/views.coffee'

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

renderPlayerList = ->
  Views.playerList.render players: _(Game.players).values()

gameChannel.on "connection", (socket) ->
  console.log "Connecting."
  socket.emit "updatedPlayersList", renderPlayerList()

  socket.on "playerRejoined", (playerId) ->
    if player = Game.possiblyFindPlayer(playerId)
      gameChannel.emit "updatedPlayersList", renderPlayerList()
      socket.emit "playerJoined", player.id
      socket.emit "updatedHand", Views.hand.render(cards: player.perspectivalHand())
    else
      socket.emit "playerLeft", playerId

  socket.on "addPlayer", (playerData) ->
    player = Game.addPlayer(playerData)
    gameChannel.emit "updatedPlayersList", renderPlayerList()
    gameChannel.emit "updatedDeck", deckSize: Game.deck.size()
    socket.emit "playerJoined", player.id
    socket.emit "updatedHand", Views.hand.render(cards: player.perspectivalHand())

  socket.on "show", (showingPlayerId, cardIds, otherPlayerId) ->
    [showingPlayer, otherPlayer] = Game.findPlayers(showingPlayerId, otherPlayerId)
    cardData = showingPlayer.showCards(cardIds, otherPlayer)
    socket.emit "cardsRevealed", Views.revealedCards.render(cardData)

  socket.on "exchange", (playerId, cardIds) ->
    player = Game.findPlayer(playerId)
    Game.exchange player, cardIds
    gameChannel.emit "updatedDeck", deckSize: Game.deck.size(), playerId: player.id
    socket.emit "updatedHand", Views.hand.render(cards: player.perspectivalHand())

  socket.on "leaveGame", (playerId) ->
    Game.removePlayer(playerId)
    gameChannel.emit "updatedPlayersList", renderPlayerList()
    socket.emit "playerLeft", playerName

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')
