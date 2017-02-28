require_relative 'vehicle'

class Car < Vehicle

  attr_accessor :num_seats

  def initialize(registration, weight, seats)
    super(registration, weight)
    self.num_seats = seats
  end
  def what
    puts 'Car'
  end

  def to_s
    puts reg, weight, num_seats
  end
end
