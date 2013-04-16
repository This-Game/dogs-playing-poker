
$ ->

  socket = io.connect "/game.prototype"

  socket.on "connect", ->

    socket.on "updatedCommunityCards", (cards) ->
      $('#community-cards').html(cards)

# -------------- END SOCKET.IO BINDINGS ---------------- #

  $('.controls').on 'click', '.deal-to-table', ->
    console.log 'yayuh'
    socket.emit 'dealToTable'