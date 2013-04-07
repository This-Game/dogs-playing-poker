$ ->
  console.log "LOADPAGE", $('.controls')

  setCurrentPlayer = (id) ->
    throw "WTF" if not id or id is 'null'
    $.cookie('current-player', id)

  currentPlayer = ->
    $.cookie('current-player')

  socket = io.connect("http://localhost:2222/game.prototype")
  if currentPlayer()?
    socket.emit "playerRejoined", currentPlayer()

  socket.on "connect", ->
    socket.emit "playerRejoined", currentPlayer() if currentPlayer()?

    socket.on "updatedHand", (hand) ->
      $('.card-table').html(hand)
      console.log 'hand', hand

    socket.on "updatedPlayersList", (playerListHTML) ->
      $('.current-players').html(playerListHTML)

    socket.on "playerJoined", (playerId) ->
      setCurrentPlayer playerId
      $('.controls').removeClass 'hidden'
      $('.leave-game').show()
      $('.add-player').hide()

    socket.on "playerLeft", (playerId) ->
      if currentPlayer() is playerId
        $.removeCookie("current-player")
        $('.add-player').show()
        $('.card-table').empty()

  $('.add-player .submit').click (event) ->
    player = {}
    for field in $(this.parentElement).find(':input')
      if field.type is 'text' || field.type is 'radio' and field.checked
        player[field.name] = field.value
    socket.emit "addPlayer", player

  $('.leave-game').click (event) ->
    if $.cookie("current-player")
      socket.emit "leaveGame", currentPlayer()
      $.removeCookie("current-player")
      $('.controls').addClass 'hidden'
      $('.add-player').show()
      $('.card-table').empty()

  $('.card-table').on "click", '.card', ->
    $(this).addClass 'selected'

  $('.controls').on "click", "button", ->
    button = $(this)
    originaltext = button.text()
    button.siblings().attr('disabled', 'disabled')
    button.text('Submit')
    button.click ->
      event = button.attr('class').split(' ')[1]
      cardIds = (card.id for card in $('.card-table .selected'))
      button.siblings().attr('disabled', 'disabled')
      button.text(originaltext)
      button.off('click')
      socket.emit event, currentPlayer(), cardIds
