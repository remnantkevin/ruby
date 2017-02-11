class Restaurant

  attr_accessor :name, :cuisine, :price

  def initialize(name, cuisine, price)
    @name, @cuisine, @price = name, cuisine, price
  end

end
