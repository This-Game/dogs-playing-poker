class Card
  include Comparable

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank, @suit = rank, suit
  end

  def <=>(other_card)
    self.value <=> other_card.value
  end

  def value
    case rank
      when 'Ace' then 14
      when 'King' then 13
      when 'Queen' then 12
      when 'Jack' then 11
      else; rank.to_i
    end
  end

  def face_card?
    value > 10 && value < 14
  end

  def ace?
    rank == 'Ace'
  end

  def red?
    [:diamonds, :hearts].include? suit.downcase.to_sym
  end

  def to_s
    "#{@rank} of #{@suit}"
  end

end