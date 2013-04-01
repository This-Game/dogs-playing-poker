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

    socket = io.connect("http://localhost:2222/game.prototype");
    socket.on("connect", function() {
      socket.on("disconnect", function(data) {
        return console.log("Disconnecting", data);
      });
      socket.on("updatedPlayersList", function(players) {
        var isCurrent, name, player, playerList, _results;

        playerList = $('.current-players').empty();
        _results = [];
        for (name in players) {
          player = players[name];
          isCurrent = name === $.cookie('current-player');
          _results.push(playerList.append($("<li cdata-player-name='" + name + "'>" + player.name + " is a " + player.kindOfDog + "</li>")));
        }
        return _results;
      });
      socket.on("playerJoined", function(playerName) {
        if ($.cookie("current-player" === playerName)) {
          return $('.add-player').hide();
        }
      });
      return socket.on("playerLeft", function(playerName) {
        if ($.cookie("current-player" === playerName)) {
          $.cookie("current-player", null);
          return $('.add-player').show();
        }
      });
    });
    $('.add-player .submit').click(function(event) {
      var field, player, _i, _len, _ref;

      player = {};
      _ref = $(this.parentElement).find(':input');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        field = _ref[_i];
        if (field.type === 'text' || field.type === 'radio' && field.checked) {
          player[field.name] = field.value;
        }
      }
      $.cookie("current-player", player.name);
      return socket.emit("addPlayer", player);
    });
    return $('.leave-game').click(function(event) {
      return socket.emit("leave-game", $.cookie("current-player"));
    });
  });

}).call(this);
