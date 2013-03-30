require 'deck'
require 'card'
require 'dog'
require 'rubygems'
require 'chance'

deck = Deck.new

%w{2 3 4 5 6 7 8 9 10 Jack Queen King Ace}.each do |rank|
  %w{Spades Hearts Diamonds Clubs}.each_with_index do |suit, i|
    deck.cards << Card.new(rank, suit)
  end
end

hand1 = 5.times.collect { deck.cards.random_pop}

puts "The true hand:"
puts hand1
puts
puts

Dog.dogs.each do |class_of_dog|
  dog = class_of_dog.new
  puts dog.name + " will now read the cards."
  dog.read hand1
  puts
  puts
end