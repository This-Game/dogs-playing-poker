(function() {
  $(function() {
    var socket;

    socket = io.connect("/game.prototype");
    socket.on("connect", function() {
      return socket.on("updatedCommunityCards", function(cards) {
        return $('#community-cards').html(cards);
      });
    });
    return $('.controls').on('click', '.deal-to-table', function() {
      console.log('yayuh');
      return socket.emit('dealToTable');
    });
  });

}).call(this);
