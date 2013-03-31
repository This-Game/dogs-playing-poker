class Deck
  attr_reader :cards

  def initialize
    @cards = []
    %w{2 3 4 5 6 7 8 9 10 Jack Queen King Ace}.each do |rank|
      %w{Spades Hearts Diamonds Clubs}.each_with_index do |suit, i|
        @cards << Card.new(rank, suit)
      end
    end
    shuffle!
  end

  def shuffle!
    @cards.shuffle!
  end

  def size
    @cards.size
  end
  alias :length :size
end