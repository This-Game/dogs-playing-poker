(function() {
  $(function() {
    var socket;

    console.log("Here we go!");
    socket = io.connect("http://localhost:2222");
    socket.on("connect", function() {
      socket.on("addPlayer", function(data) {
        return console.log("Event!", data);
      });
      socket.on("disconnect", function() {});
      return socket.on("playerAdded", function(data) {
        return console.log("Yeah buddy", data);
      });
    });
    return socket.emit("addPlayer", {
      tonto: "racists"
    });
  });

}).call(this);
