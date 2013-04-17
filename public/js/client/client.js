(function() {
  var makeDogName;

  makeDogName = function() {
    var firstNames, lastNames;

    firstNames = ['Wiggles', 'Spots', 'Rumples', 'Hank', 'Max', 'Buddy', 'Rocky', 'Lassie'];
    lastNames = ['Roverly', 'Clegane', 'Spottington', 'Sniftler', 'Schmupft', 'Sanchez', "O'Brien"];
    return firstNames[Math.floor(Math.random() * firstNames.length)] + ' ' + lastNames[Math.floor(Math.random() * lastNames.length)];
  };

  $(function() {
    var currentPlayer, resetControls, setCurrentPlayer, socket;

    $('.revealed-cards').modal({
      show: false
    });
    $('.add-player [name="name"]').val(makeDogName()).trigger('focus');
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
      $('#your-cards .card').removeClass('selected');
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
        return $('#your-cards').html(hand);
      });
      socket.on("updatedCommunityCards", function(cards) {
        return $('#community-cards').html(cards);
      });
      socket.on("updatedPlayersList", function(playerListHTML) {
        return $('.current-players').html(playerListHTML);
      });
      socket.on("playerJoined", function(playerId) {
        setCurrentPlayer(playerId);
        $('.controls').removeClass('hidden');
        $('.leave-game').show();
        $('.add-player').hide();
        return $(".players #" + (currentPlayer())).addClass("thats-you");
      });
      socket.on("playerLeft", function(playerId) {
        if (currentPlayer() === playerId) {
          $.removeCookie("current-player");
          $('.add-player').show();
          return $('.card-table').empty();
        }
      });
      socket.on("askToShow", function(html) {
        var dialog;

        dialog = $(html);
        $('body').append(dialog);
        return dialog.modal();
      });
      return socket.on("cardsRevealed", function(html) {
        var dialog;

        dialog = $(html);
        $('body').append(dialog);
        return dialog.modal();
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
    $(document).on('click', '.confirm-card .btn-primary', function() {
      var modal;

      modal = $(this).parents('.confirm-card');
      socket.emit("doShow", modal.data('showing-player-id'), modal.data('cardIds'), modal.data('shownPlayerId'));
      return modal.modal('hide');
    });
    $('#your-cards').on("click", '.card', function() {
      return $(this).toggleClass('selected');
    });
    $('.players').on("click", '.player', function() {
      var el;

      el = $(this);
      if (!el.hasClass('thats-you')) {
        return el.toggleClass('selected');
      }
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
          if ($('.players .player.selected')[0]) {
            otherPlayerId = $('.players .player.selected')[0].id;
          }
          socket.emit(event, currentPlayer(), cardIds, otherPlayerId);
        } else {
          socket.emit(event, currentPlayer(), cardIds);
        }
        return resetControls();
      });
    });
  });

}).call(this);
