(function() {
  $(function() {
    var socket;

    socket = io.connect("/game.prototype");
    socket.on("connect", function() {
      return socket.on("updatedCommunityCards", function(cards) {
        return $('#community-cards').html(cards);
      });
    });
    $('.controls').on('click', '.deal-to-table', function() {
      return socket.emit('dealToTable');
    });
    return $('.controls').on('click', '.reset-game', function() {
      return socket.emit('resetGame');
    });
  });

}).call(this);
