class Dog

  def self.all
    [Collie, Greyhound, Pug, Corgi]
  end

  def name
    self.class.to_s
  end

  def read cards
    cards.each do |card|
      puts value_for card
    end
  end

  def value_for card
    raise "Plz implement this on your own damn dog"
  end

end

# Collies know numbers and letters, i.e. anything but face cards
class Collie < Dog
  def value_for card
    val = if card.face_card?
      "Person"
    else
      card.value
    end
    "#{val} of blobs"
  end
end

# Greyhounds can recognize Faces and Aces
class Greyhound < Dog
  def value_for card
    val = if card.face_card? || card.ace?
      card.rank
    else
      "Some number"
    end
    "#{val} of blobs"
  end
end

# Pugs can see COLOR
# They can tell numbers and colors apart, but can't be more specific than that.
class Pug < Dog
  def value_for card
    color = card.red?? "Red" : "Black"
    rank = card.face_card?? "Person" : "Number"
    "#{rank} of #{color}"
  end
end

# Pugs can make out shapes; i.e. they know suits
class Corgi < Dog
  def value_for card
    suit = card.suit
    "Something of #{suit}"
  end
end