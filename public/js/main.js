(function() {
  var Card, Deck, Dog, DogsPlayingPoker, classOfDog, deck, dog, hand, _i, _len, _ref;

  DogsPlayingPoker = module.exports = {};

  Card = require('coffee/card.coffee').Card;

  Deck = require('coffee/deck.coffee').Deck;

  Dog = require('coffee/dog.coffee').Dog;

  _ref = Dog.all;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    classOfDog = _ref[_i];
    dog = new classOfDog;
    deck = new Deck;
    hand = deck.take(5);
    console.log("The " + (dog.name()) + " reads its hand:");
    dog.read(hand);
    console.log('--------------');
    console.log();
  }

}).call(this);
