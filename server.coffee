_ = require('underscore')
io = require("socket.io")
express = require("express")

app = express()
server = require("http").createServer(app)
app.configure -> app.use(express.static(__dirname + '/public'))
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')

ioServer = io.listen(server)
server.listen 2222

{Game} = require 'game.coffee'
gameChannel = ioServer.of '/game.prototype'

gameChannel.on "connection", (socket) ->
  console.log "Connecting to #{socket}"
  socket.emit "updatedPlayersList", Game.players

  socket.on "addPlayer", (playerData) ->
    console.log "Adding Player #{playerData}, now we have", Game.players
    Game.addPlayer(playerData)
    gameChannel.emit "updatedPlayersList", Game.players
    socket.emit "playerJoined", playerData.name
    socket.emit "updatedHand", playerData.hand

  socket.on "leave-game", (playerName) ->
    console.log "Removing Player #{playerName}, now we have", Game.players
    delete Game.players[playerName]
    gameChannel.emit "updatedPlayersList", Game.players
    socket.emit "playerLeft", playerName
