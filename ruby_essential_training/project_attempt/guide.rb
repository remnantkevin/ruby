class Guide

  attr_accessor :restaurants #why do you need this? as opposed to just referncing the variable?

  def initialize(restaurants)
    @restaurants = restaurants
  end

  def display(sorted="name") #best way do this?[this type of arg]
    #best way to do this? [in or out of the sort?]
    #in place or not?
    #else? just force 0?
    restaurants.sort! do |r1,r2|
      case sorted
        when "name"
          r1.name <=> r2.name
        when "cuisine"
          r1.cuisine <=> r2.cuisine
        when "price"
           r1.price <=> r2.price

          # if r1.price > r2.price 1
          # elsif r2.price > r1.price -1
          # else 0
          # end

        else
          0
      end
    end

    print_guide(restaurants)

  end

  def print_guide(restaurants)
    ## should the next section be its own function? separate to sorting?
    puts "%-30s%-20s%-10s" % ["NAME", "CUISINE", "PRICE"]

    # when the line below is not commented out, then "restaurant" in the each block changes colour??
    # print "NAME".center(30),"CUISINE".center(20),"PRICE".center(10)
    # puts

    restaurants.each do |restaurant| #naming for blockvar?
      # puts "#{restaurant.name}\t#{restaurant.cuisine}\t$#{restaurant.price}.00"
      puts "%-30s%-20s%-10s" % [restaurant.name.capitalize, restaurant.cuisine.capitalize, "$#{restaurant.price}.00"] #why diff colour? #better way to do $formatting?
    end
  end

  #title case method?

  def find(word) #when use default values?
    # create this array?
    matched_restaurants = restaurants.select do |restaurant|
      #downcase even if know never change restaurant array text?
      if restaurant.name.downcase.match?(word.downcase) || restaurant.cuisine.downcase.match?(word.downcase)
        true
      end
    end
    print_guide(matched_restaurants)
  end

  def add_restaurant(restaurant) #name of method?
    restaurants << restaurant
    puts "Restaurant successfully added"
  end

end
