$ ->
  setCurrentPlayer = (id) ->
    throw "WTF" if not id or id is 'null'
    $.cookie('current-player', id)

  socket = io.connect("http://localhost:2222/game.prototype")
  if $.cookie('current-player')?
    socket.emit("playerRejoined", $.cookie('current-player'))

  socket.on "connect", ->
    if $.cookie('current-player')?
      socket.emit "playerRejoined", $.cookie('current-player')

    socket.on "updatedHand", (hand) ->
      $('.card-table').html(hand)
      console.log 'hand', hand

    socket.on "updatedPlayersList", (playerListHTML) ->
      $('.current-players').html(playerListHTML)

    socket.on "playerJoined", (playerId) ->
      setCurrentPlayer playerId
      $('.leave-game').show()
      $('.add-player').hide()

    socket.on "playerLeft", (playerId) ->
      if $.cookie "current-player" is playerId
        $.removeCookie("current-player")
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
