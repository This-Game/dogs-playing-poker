makeDogName = ->
  firstNames = ['Wiggles', 'Spots', 'Rumples', 'Hank', 'Max', 'Buddy', 'Rocky', 'Lassie']
  lastNames = ['Roverly', 'Clegane', 'Spottington', 'Sniftler', 'Schmupft', 'Sanchez', "O'Brien"]
  firstNames[Math.floor(Math.random() * firstNames.length)] + ' ' +
  lastNames[Math.floor(Math.random() * lastNames.length)]

$ ->
  $('.revealed-cards').modal show: false
  $('.add-player [name="name"]').val(makeDogName()).trigger('focus')

  currentPlayer = ->
    $.cookie('current-player')

  setCurrentPlayer = (id) ->
    throw "Current Player must be an id" if not id or id is 'null'
    $.cookie('current-player', id)

  resetControls = ->
    $('#your-cards .card').removeClass 'selected'
    $('.player').removeClass 'selected'
    $('.controls button').each (index, element) ->
      $el = $(element)
      $el.removeAttr 'disabled'
      $el.text $el.data('text')

  socket = io.connect "/game.prototype"
  socket.emit "playerRejoined", currentPlayer() if currentPlayer()?

# -------------- SOCKET.IO BINDINGS ---------------- #
  socket.on "connect", ->
    socket.emit "playerRejoined", currentPlayer() if currentPlayer()?

    socket.on "updatedHand", (hand) ->
      $('#your-cards').html(hand)

    socket.on "updatedCommunityCards", (cards) ->
      $('#community-cards').html(cards)

    socket.on "updatedPlayersList", (playerListHTML) ->
      $('.current-players').html(playerListHTML)

    socket.on "playerJoined", (playerId) ->
      setCurrentPlayer playerId
      $('.controls').removeClass 'hidden'
      $('.leave-game').show()
      $('.add-player').hide()
      $(".players ##{currentPlayer()}").addClass("thats-you")

    socket.on "playerLeft", (playerId) ->
      if currentPlayer() is playerId
        $.removeCookie("current-player")
        $('.add-player').show()
        $('.card-table').empty()

    socket.on "askToShow", (html) ->
      dialog = $(html)
      $('body').append(dialog)
      dialog.modal()

    socket.on "cardsRevealed", (html) ->
      dialog = $(html)
      $('body').append(dialog)
      dialog.modal()
      debugger

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

  $(document).on 'click', '.confirm-card .btn-primary', ->
    modal = $(this).parents('.confirm-card')
    socket.emit "doShow", modal.data('showing-player-id'), modal.data('cardIds'), modal.data('shownPlayerId')
    modal.modal('hide')

  $('#your-cards').on "click", '.card', ->
    $(this).toggleClass 'selected'

  $('.players').on "click", '.player', ->
    el = $(this)
    el.toggleClass 'selected' unless el.hasClass('thats-you')

  $('.controls').on "click", "button", ->
    button = $(this)
    originaltext = button.text()
    button.siblings().attr('disabled', 'disabled')
    button.text('Submit')
    button.click ->
      button.off 'click'
      event = button.attr('class').split(' ')[1]
      cardIds = (card.id for card in $('.card-table .selected'))
      if event is 'show'
        otherPlayerId = $('.players .player.selected')[0].id if $('.players .player.selected')[0]
        socket.emit event, currentPlayer(), cardIds, otherPlayerId
      else
        socket.emit event, currentPlayer(), cardIds
      resetControls()
