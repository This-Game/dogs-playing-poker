require 'deck'
require 'card'
require 'player'

deck = Deck.new

%w{A 2 3 4 5 6 7 8 9 10 J Q K}.each do |rank|
  %w{Spades Hearts Diamonds Clubs}.each_with_index do |suit, i|
    deck.cards << Card.new(rank, suit)
  end
end

puts deck.cards