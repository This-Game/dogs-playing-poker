(function() {
  $.fn.serializeObject = function() {
    var a, o;

    o = {};
    a = this.serializeArray();
    return $.each(a, function() {
      if (o[this.name] !== undefined) {
        if (!o[this.name].push) {
          o[this.name] = [o[this.name]];
        }
        return o[this.name].push(this.value || "");
      } else {
        return o[this.name] = this.value || "";
      }
    });
  };

  $(function() {
    var socket;

    console.log("Here we go!");
    socket = io.connect("http://localhost:2222");
    socket.on("connect", function() {
      socket.on("addPlayer", function(data) {
        return console.log("Event!", data);
      });
      socket.on("disconnect", function(data) {
        return console.log("Disconnecting", data);
      });
      return socket.on("playerAdded", function(players) {
        var name, player, playerList, _results;

        playerList = $('.current-players').empty();
        _results = [];
        for (name in players) {
          player = players[name];
          _results.push(playerList.append($("<li data-player-name='" + name + "'>" + player.name + " is a " + player.kindOfDog + "</li>")));
        }
        return _results;
      });
    });
    return $('form.add-player input[type=submit]').click(function(event) {
      var field, player, _i, _len, _ref;

      event.stopPropagation();
      player = {};
      _ref = $(this.parentElement).find(':input');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        field = _ref[_i];
        if (field.type === 'text' || field.type === 'radio' && field.checked) {
          player[field.name] = field.value;
        }
      }
      socket.emit("addPlayer", player);
      return false;
    });
  });

}).call(this);
