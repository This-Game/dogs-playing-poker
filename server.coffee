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

# Now let's set up and start listening for events
io.sockets.on "connection", (socket) ->
  console.log "Connecting to #{socket}"
  # We're connected to someone now. Let's listen for events from them
  socket.on "addPlayer", (data) ->
    console.log "Player added sheyeah"
    # We've received some data. Let's just log it
    console.log data

    # Now let's reply
    socket.emit "playerAdded",
      players = [1,2,3,4]


