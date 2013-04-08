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

gameChannel.on "connection", (socket) ->
  console.log "Connecting."
  socket.emit "updatedPlayersList", renderPlayerList()

  socket.on "playerRejoined", (playerId) ->
    if player = game.possiblyFindPlayer(playerId)
      gameChannel.emit "updatedPlayersList", renderPlayerList()
      gameChannel.emit "updatedCommunityCards", renderCommunityCards()
      socket.emit "playerJoined", player.id
      socket.emit "updatedHand", Views.hand.render(cards: player.perspectivalHand())
    else
      socket.emit "playerLeft", playerId

  socket.on "addPlayer", (playerData) ->
    player = game.addPlayer(playerData)
    gameChannel.emit "updatedPlayersList", renderPlayerList()
    gameChannel.emit "updatedCommunityCards", renderCommunityCards()
    gameChannel.emit "updatedDeck", deckSize: game.deck.size()
    socket.emit "playerJoined", player.id
    socket.emit "updatedHand", Views.hand.render(cards: player.perspectivalHand())

  socket.on "show", (showingPlayerId, cardIds, otherPlayerId) ->
    [showingPlayer, otherPlayer] = game.findPlayers(showingPlayerId, otherPlayerId)
    cardData = showingPlayer.showCards(cardIds, otherPlayer)
    socket.emit "cardsRevealed", Views.revealedCards.render(cardData)

  socket.on "exchange", (playerId, cardIds) ->
    player = game.findPlayer(playerId)
    game.exchange player, cardIds
    gameChannel.emit "updatedDeck", deckSize: game.deck.size(), playerId: player.id
    socket.emit "updatedHand", Views.hand.render(cards: player.perspectivalHand())

  socket.on "leaveGame", (playerId) ->
    game.removePlayer(playerId)
    gameChannel.emit "updatedPlayersList", renderPlayerList()
    socket.emit "playerLeft", playerName

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

app.get '/dealer', (req, res) ->
  res.send Views.dealer.render(
    communityCards:
      cards: game.communityCards
    deckSize: game.deck.size()
    playerList: game.players
  )

