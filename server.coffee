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
game = new Game

renderPlayerList = ->
  Views.playerList.render players: _(game.players).values()

renderCommunityCards = ->
  Views.hand.render cards: game.communityCards

renderPlayerHand = (player) ->
  Views.hand.render cards: player.perspectivalHand()

gameChannel.on "connection", (socket) ->
  socket.emit "updatedPlayersList", renderPlayerList()

  socket.on "playerRejoined", (playerId) ->
    if player = game.possiblyFindPlayer(playerId)
      player.socketId = socket.id
      gameChannel.emit "updatedPlayersList", renderPlayerList()
      gameChannel.emit "updatedCommunityCards", renderCommunityCards()
      socket.emit "playerJoined", player.id
      socket.emit "updatedHand", renderPlayerHand(player)
    else
      socket.emit "playerLeft", playerId

  socket.on "addPlayer", (playerData) ->
    player = game.addPlayer(playerData)
    player.socketId = socket.id
    gameChannel.emit "updatedPlayersList", renderPlayerList()
    gameChannel.emit "updatedCommunityCards", renderCommunityCards()
    gameChannel.emit "updatedDeck", deckSize: game.deck.size()
    socket.emit "playerJoined", player.id
    socket.emit "updatedHand", renderPlayerHand(player)

  socket.on "doShow", (showingPlayerId, cardIds, otherPlayerId) ->
    [showingPlayer, otherPlayer] = game.findPlayers(showingPlayerId, otherPlayerId)
    cardData = showingPlayer.showCards(cardIds, otherPlayer)
    socket.emit "cardsRevealed", Views.revealedCards.render(cardData)
    console.log "SOCKITOOMEE", showingPlayer.socketId, otherPlayer.socketId, ioServer.sockets.socket(otherPlayer.socketId)
    ioServer.sockets.socket(otherPlayer.socketId).emit("shownAnothersCards", cardData.asTheySeeIt);

  socket.on "show", (showingPlayerId, cardIds, otherPlayerId) ->
    [showingPlayer, otherPlayer] = game.findPlayers(showingPlayerId, otherPlayerId)
    ioServer.of('/game.prototype').sockets[otherPlayer.socketId].emit("askToShow", playerName: showingPlayer.name, cardIds: cardIds)

  socket.on "exchange", (playerId, cardIds) ->
    player = game.findPlayer(playerId)
    game.exchange player, cardIds
    gameChannel.emit "updatedDeck", deckSize: game.deck.size(), playerId: player.id
    socket.emit "updatedHand", renderPlayerHand(player)

  socket.on "resetGame", ->
    game = new Game
    socket.emit "updatedHand", renderPlayerHand(player)
    gameChannel.emit "updatedCommunityCards", renderCommunityCards()
    gameChannel.emit "updatedPlayersList", renderPlayerList()

  socket.on "dealToTable", (num = 1) ->
    game.dealCommunityCards num
    gameChannel.emit "updatedCommunityCards", renderCommunityCards()

  socket.on "leaveGame", (playerId) ->
    game.removePlayer(playerId)
    gameChannel.emit "updatedPlayersList", renderPlayerList()
    socket.emit "playerLeft", playerId

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

app.get '/dealer', (req, res) ->
  context =
    communityCards:
      cards: game.communityCards
    deckSize: game.deck.size()
    players: _(game.players).values()
    playerList:
      players: _(game.players).values()

  html = Views.dealer.render context, Views
  res.send html

