require_relative 'vehicle'

class Bike < Vehicle

  attr_accessor :helmet

  def initialize(registration, weight, helmet)
    super(registration, weight)
    self.helmet = helmet
  end
end
