(function() {
  var Card;

  Card = (function() {
    function Card(rank, suit) {
      this.rank = rank;
      this.suit = suit;
    }

    Card.prototype.value = function() {
      switch (this.rank) {
        case "A":
          return 14;
        case "K":
          return 13;
        case "Q":
          return 12;
        case "J":
          return 11;
        default:
          return this.rank;
      }
    };

    Card.prototype.isAce = function() {
      return this.rank === 'A';
    };

    Card.prototype.isFaceCard = function() {
      return this.value > 10 && this.value < 14;
    };

    Card.prototype.color = function() {
      var _ref;

      if ((_ref = this.suit) === "Diamonds" || _ref === "Hearts") {
        return "Red";
      } else {
        return "Black";
      }
    };

    Card.prototype.toString = function() {
      return "" + (this.rankName()) + " of " + this.suit;
    };

    Card.prototype.rankName = function() {
      switch (this.rank) {
        case "A":
          return "Ace";
        case "K":
          return "K";
        case "Q":
          return "Queen";
        case "J":
          return "Jack";
        default:
          return this.rank;
      }
    };

    Card.prototype.suitSymbol = function() {
      switch (this.suit) {
        case "Diamonds":
          return '&diams;';
        case "Hearts":
          return '&hearts;';
        case "Spades":
          return '&spades;';
        case "Clubs":
          return '&clubs;';
        default:
          return '&#9800;';
      }
    };

    Card.prototype.suitClass = function() {
      return this.suit.toLowerCase();
    };

    return Card;

  })();

  exports.Card = Card;

}).call(this);
