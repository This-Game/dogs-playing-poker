$.fn.serializeObject = ->
  o = {}
  a = @serializeArray()
  $.each a, ->
    if o[@name] isnt `undefined`
      o[@name] = [o[@name]]  unless o[@name].push
      o[@name].push @value or ""
    else
      o[@name] = @value or ""

$ ->
  console.log "Here we go!"
  socket = io.connect("http://localhost:2222")
  socket.on "connect", ->
    socket.on "addPlayer", (data) ->
      console.log "Event!", data

    socket.on "disconnect", (data) ->
      console.log "Disconnecting", data

    socket.on "playerAdded", (players) ->
      playerList = $('.current-players').empty()
      for name, player of players
        playerList.append $("<li data-player-name='#{name}'>#{player.name} is a #{player.kindOfDog}</li>")

  $('form.add-player input[type=submit]').click (event) ->
    event.stopPropagation();
    player = {}
    for field in $(this.parentElement).find(':input')
      if field.type is 'text' || field.type is 'radio' and field.checked
        player[field.name] = field.value
    socket.emit "addPlayer", player
    false


