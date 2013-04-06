$ ->
  socket = io.connect("http://localhost:2222/game.prototype")
  if $.cookie 'current-player'
    console.log "Jankypants"
    socket.emit("playerRejoined", $.cookie('current-player'))

  socket.on "connect", ->
    if $.cookie 'current-player'
      socket.emit "playerRejoined", $.cookie('current-player')

    socket.on "updatedHand", (hand) ->
      $('.card-table').html(hand)
      console.log 'hand', hand

    socket.on "updatedPlayersList", (players) ->
      playerList = $('.current-players').empty()
      for id, player of players
        isCurrent = id == $.cookie('current-player')
        playerList.append $("<li cdata-player-id='#{id}'>#{player.name} is a #{player.kindOfDog}</li>")

    socket.on "playerJoined", (playerId) ->
      if playerId
        $.cookie('current-player', playerId) if playerId
        $('.leave-game').show()
        $('.add-player').hide()

    socket.on "playerLeft", (playerId) ->
      if $.cookie "current-player" is playerId
        $.cookie("current-player", null)
        $('.add-player').show()
        $('.card-table').empty()

  $('.add-player .submit').click (event) ->
    player = {}
    for field in $(this.parentElement).find(':input')
      if field.type is 'text' || field.type is 'radio' and field.checked
        player[field.name] = field.value
    $.cookie "current-player", player.id
    socket.emit "addPlayer", player

  $('.leave-game').click (event) ->
    if $.cookie("current-player")
      socket.emit "leaveGame", $.cookie("current-player")
      $.removeCookie("current-player")
      $('.add-player').show()
      $('.card-table').empty()

  $('.card-table').on "click", ".btn.trade", (event) ->
    cardId = @parentElement.id
    socket.emit "exchangeCards", $.cookie("current-player"), [cardId]
