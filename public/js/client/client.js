(function() {
  $(function() {
    var currentPlayer, resetControls, setCurrentPlayer, socket;

    $('.modal').modal({
      show: false
    });
    currentPlayer = function() {
      return $.cookie('current-player');
    };
    setCurrentPlayer = function(id) {
      if (!id || id === 'null') {
        throw "Current Player must be an id";
      }
      return $.cookie('current-player', id);
    };
    resetControls = function() {
      console.log("resetting");
      $('.card').removeClass('selected');
      $('.player').removeClass('selected');
      return $('.controls button').each(function(index, element) {
        var $el;

        $el = $(element);
        $el.removeAttr('disabled');
        return $el.text($el.data('text'));
      });
    };
    socket = io.connect("/game.prototype");
    if (currentPlayer() != null) {
      socket.emit("playerRejoined", currentPlayer());
    }
    socket.on("connect", function() {
      if (currentPlayer() != null) {
        socket.emit("playerRejoined", currentPlayer());
      }
      socket.on("updatedHand", function(hand) {
        return $('.card-table').html(hand);
      });
      socket.on("updatedPlayersList", function(playerListHTML) {
        return $('.current-players').html(playerListHTML);
      });
      socket.on("playerJoined", function(playerId) {
        setCurrentPlayer(playerId);
        $('.controls').removeClass('hidden');
        $('.leave-game').show();
        return $('.add-player').hide();
      });
      socket.on("playerLeft", function(playerId) {
        if (currentPlayer() === playerId) {
          $.removeCookie("current-player");
          $('.add-player').show();
          return $('.card-table').empty();
        }
      });
      return socket.on("cardsRevealed", function(html) {
        var dialog;

        console.log("JAIS JAIS JAIS", html);
        dialog = $('.modal');
        dialog.find('h3').text("Cards have been revealed!");
        dialog.find('.modal-body p').html(html);
        return dialog.modal("show");
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
      return socket.emit("addPlayer", player);
    });
    $('.leave-game').click(function(event) {
      if ($.cookie("current-player")) {
        socket.emit("leaveGame", currentPlayer());
        $.removeCookie("current-player");
        $('.controls').addClass('hidden');
        $('.add-player').show();
        return $('.card-table').empty();
      }
    });
    $('.card-table').on("click", '.card', function() {
      return $(this).addClass('selected');
    });
    $('.players').on("click", '.player', function() {
      return $(this).addClass('selected');
    });
    return $('.controls').on("click", "button", function() {
      var button, originaltext;

      button = $(this);
      originaltext = button.text();
      button.siblings().attr('disabled', 'disabled');
      button.text('Submit');
      return button.click(function() {
        var card, cardIds, event, otherPlayerId;

        button.off('click');
        event = button.attr('class').split(' ')[1];
        cardIds = (function() {
          var _i, _len, _ref, _results;

          _ref = $('.card-table .selected');
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            card = _ref[_i];
            _results.push(card.id);
          }
          return _results;
        })();
        if (event === 'show') {
          otherPlayerId = $('.players .player.selected')[0].id;
          socket.emit(event, currentPlayer(), cardIds, otherPlayerId);
        } else {
          socket.emit(event, currentPlayer(), cardIds);
        }
        return resetControls();
      });
    });
  });

}).call(this);
