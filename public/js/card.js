(function() {
  var Card;

  Card = (function() {
    function Card(rank, suit) {
      this.rank = rank;
      this.suit = suit;
    }

    Card.prototype.value = function() {
      switch (day) {
        case "Ace":
          return 14;
        case "King":
          return 13;
        case "Queen":
          return 12;
        case "Jack":
          return 11;
        default:
          return this.rank;
      }
    };

    Card.prototype.isAce = function() {
      return this.rank === 'Ace';
    };

    Card.prototype.isFaceCard = function() {
      return this.value > 10 && this.value < 14;
    };

    Card.prototype.isRed = function() {
      var _ref;

      return (_ref = this.suit) === "Diamonds" || _ref === "Hearts";
    };

    Card.prototype.toString = function() {
      return "" + this.rank + " of " + this.suit;
    };

    return Card;

  })();

  exports.Card = Card;

}).call(this);
