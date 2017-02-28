class Vehicle

  attr_accessor :reg, :weight

  def initialize(registration, weight)
    self.reg = registration
    self.weight = weight
  end

  def what
    puts 'Vehicle'
  end

  def to_s
    puts reg, weight
  end

end

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

class Bike < Vehicle

  attr_accessor :helmet

  def initialize(registration, weight, helmet)
    super(registration, weight)
    self.helmet = helmet
  end
end

class Truck < Car

  attr_accessor :carry_capacity

  def initialize(registration, weight, seats, capacity)
    super(registration, weight, seats)
    self.carry_capacity = capacity
  end

end
