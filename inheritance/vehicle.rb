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
