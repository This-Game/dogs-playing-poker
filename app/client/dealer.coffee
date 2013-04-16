
$ ->

  socket = io.connect "/game.prototype"

  socket.on "connect", ->

    socket.on "updatedCommunityCards", (cards) ->
      $('#community-cards').html(cards)

# -------------- END SOCKET.IO BINDINGS ---------------- #

  $('.controls').on 'click', '.deal-to-table', ->
    socket.emit 'dealToTable'

  $('.controls').on 'click', '.reset-game', ->
    socket.emit 'resetGame'