require_relative 'car'

class Truck < Car

  attr_accessor :carry_capacity

  def initialize(registration, weight, seats, capacity)
    super(registration, weight, seats)
    self.carry_capacity = capacity
  end

end
