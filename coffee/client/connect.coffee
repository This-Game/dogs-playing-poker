$ ->
  currentPlayer = ->
    $.cookie('current-player')

  setCurrentPlayer = (id) ->
    throw "WTF" if not id or id is 'null'
    $.cookie('current-player', id)

  resetControls = ->
    $('.card').removeClass 'selected'
    $('.player').removeClass 'selected'
    $('.controls button').each (index, element) ->
      $el = $(element)
      $el.removeAttr 'disabled'
      $el.text $el.data('text')

  $('.modal').modal show: false

  socket = io.connect "http://localhost:2222/game.prototype"
  socket.emit "playerRejoined", currentPlayer() if currentPlayer()?
# -------------- SOCKET.IO BINDINGS ---------------- #

  socket.on "connect", ->
    socket.emit "playerRejoined", currentPlayer() if currentPlayer()?

    socket.on "updatedHand", (hand) ->
      $('.card-table').html(hand)

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

    socket.on "cardsRevealed", (html) ->
      console.log "JAIS JAIS JAIS", html
      dialog = $('.modal')
      dialog.find('h3').text("Cards have been revealed!")
      dialog.find('.modal-body p').html(html)
      dialog.modal("show")

# -------------- UI BINDINGS ---------------- #

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

  $('.players').on "click", '.player', ->
    $(this).addClass 'selected'

  $('.controls').on "click", "button", ->
    button = $(this)
    originaltext = button.text()
    button.siblings().attr('disabled', 'disabled')
    button.text('Submit')
    button.click ->
      button.off 'click'
      event = button.attr('class').split(' ')[1]
      cardIds = (card.id for card in $('.card-table .selected'))
      otherPlayerId = if event is 'exchange'
        $('.players .player.selected')[0].id
      else
        null
      socket.emit event, currentPlayer(), cardIds, otherPlayerId
      resetControls()
