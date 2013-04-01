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
  socket = io.connect("http://localhost:2222/game.prototype")
  socket.on "connect", ->
    # socket.on "disconnect", (data) ->
    #   console.log "Disconnecting", data

    socket.on "updatedHand", (hand) ->
      console.log("HAND", hand)

    socket.on "updatedPlayersList", (players) ->
      playerList = $('.current-players').empty()
      for name, player of players
        isCurrent = name == $.cookie('current-player')
        playerList.append $("<li cdata-player-name='#{name}'>#{player.name} is a #{player.kindOfDog}</li>")

    socket.on "playerJoined", (playerName) ->
      if $.cookie "current-player" is playerName
        $('.add-player').hide();

    socket.on "playerLeft", (playerName) ->
      if $.cookie "current-player" is playerName
        $.cookie("current-player", null)
        $('.add-player').show();

  $('.add-player .submit').click (event) ->
    player = {}
    for field in $(this.parentElement).find(':input')
      if field.type is 'text' || field.type is 'radio' and field.checked
        player[field.name] = field.value
    $.cookie "current-player", player.name
    socket.emit "addPlayer", player

  $('.leave-game').click (event) ->
    socket.emit "leave-game", $.cookie("current-player")



