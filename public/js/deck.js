(function() {
  var Card, Deck;

  Card = require('coffee/card.coffee').Card;

  Deck = (function() {
    function Deck() {
      var rank, suit, _i, _j, _len, _len1, _ref, _ref1;

      this.cards = [];
      _ref = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        rank = _ref[_i];
        _ref1 = ['Spades', 'Hearts', 'Diamonds', 'Clubs'];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          suit = _ref1[_j];
          this.cards.push(new Card(rank, suit));
        }
      }
      this.shuffle();
    }

    Deck.prototype.shuffle = function() {
      var element, randomElement, _i, _ref, _ref1;

      for (element = _i = _ref = this.cards.length - 1; _ref <= 1 ? _i <= 1 : _i >= 1; element = _ref <= 1 ? ++_i : --_i) {
        randomElement = Math.floor(Math.random() * (element + 1));
        _ref1 = [this.cards[randomElement], this.cards[element]], this.cards[element] = _ref1[0], this.cards[randomElement] = _ref1[1];
      }
      return this.cards;
    };

    Deck.prototype.size = function() {
      return this.cards.length;
    };

    Deck.prototype.take = function(number) {
      return this.cards.slice(0, number);
    };

    return Deck;

  })();

  exports.Deck = Deck;

}).call(this);
