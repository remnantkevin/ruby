require_relative 'restaurant'
require './guide'

#functions here in init? e.g. read in file?

restaurants = [] #proper way?
File.open("data.txt","r") do |file|
  #while line = file.gets
  file.each_line do |line|
    line_split = line.chomp.split(',')
    restaurants << Restaurant.new(line_split[0],line_split[1],line_split[2].to_i) #to_i
  end
end

# actions: list/list by cuisine/list by price/find/add/quit

listings = Guide.new(restaurants)
puts "RESTAURANT LIST\n\n"
user_input = "" #proper way?
while user_input != "quit"
  case user_input
  when "list", "l"
    listings.display
  when "list by cuisine", "lbc"
    listings.display("cuisine")
  when "list by price", "lbp"
    listings.display("price")
  when "find"
    print "Type search term\n>> "
    listings.find(gets.chomp.strip)
  when "add"
    puts "New restaurant details"
    print "Name >> "
    name = gets.chomp.downcase
    print "Cuisine >> "
    cuisine = gets.chomp.downcase
    print "Price >> "
    price = gets.chomp.downcase
    listings.add_restaurant(Restaurant.new(name,cuisine,price))
  else
    puts "options: list/list by cuisine/list by price/find/add/quit"
  end

  # does input go here? at bottom
  print ">> "
  user_input = gets.chomp #chomp here? or when check it
end

## is this and the previous code the correct way to handle file interaction? i.e. read in; use array; edit array; then write
write_file = File.new("data.txt", "w")
restaurants.each {|restaurant| write_file.puts "#{restaurant.name},#{restaurant.cuisine},#{restaurant.price}"}
write_file.close











## end ##
