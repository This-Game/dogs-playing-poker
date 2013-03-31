$ ->
  console.log "Here we go!"
  socket = io.connect("http://localhost:2222")
  socket.on "connect", ->
    socket.on "addPlayer", (data) ->
      console.log "Event!", data

    socket.on "disconnect", ->

    socket.on "playerAdded", (data) ->
      console.log "Yeah buddy", data

  socket.emit "addPlayer",
    tonto: "racists"
