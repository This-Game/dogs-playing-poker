(function() {
  var Card, Collie, Corgi, Dog, Greyhound, Human, Pug, Util, _ref, _ref1, _ref2, _ref3, _ref4,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Card = require('coffee/card.coffee').Card;

  Util = require('coffee/util.coffee').Util;

  Dog = (function() {
    function Dog(playerData, cards) {
      var _ref;

      if ((_ref = this.id) == null) {
        this.id = Util.makeGUID();
      }
      this.name = playerData.name;
      this.kindOfDog = playerData.kindOfDog;
      if (cards) {
        this.setHand(cards);
      }
    }

    Dog.newByType = function(playerData, cards) {
      var DogType;

      DogType = this.byName[playerData.kindOfDog];
      return new DogType(playerData, cards);
    };

    Dog.prototype.name = function(handOfCards) {
      return this.constructor.name;
    };

    Dog.prototype.perspectivalHand = function(aHand) {
      return this.read(aHand || this.hand);
    };

    Dog.prototype.read = function(cards) {
      var card, _i, _len, _results;

      _results = [];
      for (_i = 0, _len = cards.length; _i < _len; _i++) {
        card = cards[_i];
        _results.push(this.valueFor(card));
      }
      return _results;
    };

    Dog.prototype.valueFor = function(card) {
      if (card instanceof Card) {
        return card;
      } else {
        throw "Hot holy cold mold, " + card.constructor.name + " isn't a card.\n " + card;
      }
    };

    Dog.prototype.setHand = function(cards) {
      console.log("Setting hand", cards);
      return this.hand = cards;
    };

    Dog.prototype.showCards = function(cardIds, otherPlayer) {
      var cards, id;

      cards = (function() {
        var _i, _len, _results;

        _results = [];
        for (_i = 0, _len = cardIds.length; _i < _len; _i++) {
          id = cardIds[_i];
          _results.push(Card.reconstitute(id));
        }
        return _results;
      })();
      return {
        asYouSeeIt: {
          cards: this.read(cards)
        },
        asTheySeeIt: {
          cards: otherPlayer.read(cards)
        }
      };
    };

    return Dog;

  })();

  Collie = (function(_super) {
    __extends(Collie, _super);

    function Collie() {
      _ref = Collie.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Collie.prototype.valueFor = function(card) {
      var rank;

      Collie.__super__.valueFor.call(this, card);
      rank = card.isFaceCard() ? "Person" : card.value();
      return new Card(rank, "blobs", card.id);
    };

    return Collie;

  })(Dog);

  Greyhound = (function(_super) {
    __extends(Greyhound, _super);

    function Greyhound() {
      _ref1 = Greyhound.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    Greyhound.prototype.valueFor = function(card) {
      var rank;

      Greyhound.__super__.valueFor.call(this, card);
      rank = card.isFaceCard() || card.isAce() ? card.rank : "Number";
      return new Card(rank, "blobs", card.id);
    };

    return Greyhound;

  })(Dog);

  Pug = (function(_super) {
    __extends(Pug, _super);

    function Pug() {
      _ref2 = Pug.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    Pug.prototype.valueFor = function(card) {
      var rank;

      Pug.__super__.valueFor.call(this, card);
      rank = card.isFaceCard() ? "Person" : "Number";
      return new Card(rank, card.color(), card.id);
    };

    return Pug;

  })(Dog);

  Corgi = (function(_super) {
    __extends(Corgi, _super);

    function Corgi() {
      _ref3 = Corgi.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    Corgi.prototype.valueFor = function(card) {
      Corgi.__super__.valueFor.call(this, card);
      return new Card("?", card.suit, card.id);
    };

    return Corgi;

  })(Dog);

  Human = (function(_super) {
    __extends(Human, _super);

    function Human() {
      _ref4 = Human.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    Human.prototype.valueFor = function(card) {
      return Human.__super__.valueFor.call(this, card);
    };

    return Human;

  })(Dog);

  Dog.byName = {
    "Collie": Collie,
    "Greyhound": Greyhound,
    "Pug": Pug,
    "Corgi": Corgi,
    "Human": Human
  };

  exports.Dog = Dog;

}).call(this);
