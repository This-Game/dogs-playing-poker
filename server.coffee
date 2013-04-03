http = require 'http'
_ = require 'underscore'
io = require "socket.io"
express = require "express"
{MustacheViews} = require 'views.coffee'
{Game} = require 'game.coffee'

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

  socket.on "rejoining", (playerName) ->
    if player = Game.players[playerName]
      socket.emit "updatedHand", MustacheViews.hand.render(player.perspectivalHand)

  socket.on "addPlayer", (playerData) ->
    console.log "Adding Player #{playerData}, now we have", Game.players
    player = Game.addPlayer(playerData)
    gameChannel.emit "updatedPlayersList", Game.players
    socket.emit "playerJoined", player.name
    socket.emit "updatedHand", MustacheViews.hand.render(player.perspectivalHand)

  socket.on "leave-game", (playerName) ->
    console.log "Removing Player #{playerName}, now we have", Game.players
    delete Game.players[playerName]
    gameChannel.emit "updatedPlayersList", Game.players
    socket.emit "playerLeft", playerName

app.get '/', (req, res) ->
  res.sendfile(__dirname + '/index.html')
