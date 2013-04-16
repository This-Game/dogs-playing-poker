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
  Views.cards.render cards: game.communityCards

renderPlayerHand = (player) ->
  Views.cards.render cards: player.perspectivalHand()

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
    [showingPlayer, shownPlayer] = game.findPlayers(showingPlayerId, otherPlayerId)
    cardData = showingPlayer.showCards(cardIds, shownPlayer)
    shownPlayerView = Views.revealedCards.render(asYouSeeIt: cardData.shownPlayer, asTheySeeIt: cardData.showingPlayer)
    showingPlayerView = Views.revealedCards.render(asYouSeeIt: cardData.showingPlayer, asTheySeeIt: cardData.shownPlayer)
    ioServer.of('/game.prototype').sockets[showingPlayer.socketId].emit "cardsRevealed", showingPlayerView
    ioServer.of('/game.prototype').sockets[shownPlayer.socketId].emit "cardsRevealed", shownPlayerView

  socket.on "show", (showingPlayerId, cardIds, otherPlayerId) ->
    [showingPlayer, otherPlayer] = game.findPlayers(showingPlayerId, otherPlayerId)
    context =
      playerName: showingPlayer.name,
      cardIds: JSON.stringify(cardIds),
      cardNumber: cardIds.length
      shownPlayerId: otherPlayerId,
      showingPlayerId: showingPlayerId
    html = Views.confirmCardReveal.render(context, Views)
    ioServer.of('/game.prototype').sockets[otherPlayer.socketId].emit("askToShow", html)

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

  socket.on "dealToPlayers", (num = 1) ->
    game.dealToPlayers(num)
    for player in _(game.players).values()
      ioServer.of('/game.prototype').sockets[player.socketId].emit("updatedHand", renderPlayerHand(player))

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

