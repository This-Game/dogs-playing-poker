(function() {
  var Collie, Corgi, Dog, Greyhound, Pug, _, _ref, _ref1, _ref2, _ref3,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  _ = require('underscore');

  Dog = (function() {
    function Dog(playerData) {
      this.name = playerData.name;
      this.kindOfDog = playerData.kindOfDog;
      this.hand = {
        cards: playerData.cards
      };
      this.perspectivalHand = {
        cards: this.read(playerData.cards)
      };
    }

    Dog.prototype.name = function(handOfCards) {
      return this.constructor.name;
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
      throw "Plz implement this on your own damn dog";
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
      var val;

      val = card.isFaceCard() ? "Person" : card.value;
      return {
        suit: "blobs",
        rank: val
      };
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
      var val;

      val = card.isFaceCard() || card.isAce() ? card.rank : "Some number";
      return {
        suit: "blobs",
        rank: val
      };
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

      rank = card.isFaceCard() ? "Person" : "Number";
      return {
        suit: card.color(),
        rank: rank
      };
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
      return {
        suit: card.suit,
        rank: "?"
      };
    };

    return Corgi;

  })(Dog);

  Dog.byName = {
    "Collie": Collie,
    "Greyhound": Greyhound,
    "Pug": Pug,
    "Corgi": Corgi
  };

  exports.Dog = Dog;

}).call(this);
