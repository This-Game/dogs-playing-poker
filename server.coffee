_ = require('underscore')
io = require("socket.io")
express = require("express")

app = express()
server = require("http").createServer(app)
io = io.listen(server)
server.listen 2222

app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router

app.get '/players', (req, res) ->
  res.json

Game = {
  players: {}
}

io.sockets.on "connection", (socket) ->
  console.log "Connecting to #{socket}"
  socket.on "addPlayer", (playerData) ->
    Game.players[playerData.name] = playerData
    console.log "Players are now", Game.players
    socket.emit "playerAdded", Game.players


