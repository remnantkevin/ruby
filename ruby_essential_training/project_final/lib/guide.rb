# ? The guide class really is going to be the heart of the food finder, because in that init.rb file, we are going to instantiate the guide class. We are going to create a new guide, right, a new instance of the guidebook. And then we will tell that guidebook, hey, guidebook take over, and at that point the guide class will take over, and it will handle all of the user input, and do all the processing of the actions that have been asked for, and handle the user output as well. So really the guide class is going to be the controller class. It is going to control what's going on.

require 'restaurant' #? dependencies
require 'support/string_helper'

class Guide

  #? no array is ever stored?

  # little bit overkill
  #? better way?
  class Config
    @@actions = ["list", "find", "add", "quit"]
    def self.actions
      @@actions
    end
  end

  # flexible path for restaurant file
  def initialize(path=nil)
    Restaurant.filepath = path

    # ? should this kind of stuff be in initialize? -- i guess makes sense cuz don't want a Guide instance which doesnt have valid associated file, so must check that upfront
    # ? control from guide class, but work done in restaurant class
    # locate restaurant text file at path
    if Restaurant.file_exists?
      puts "Found restaurant file."
    # or create a new file
    elsif Restaurant.create_file
      puts "Created restaurant file."
    # or exit if create fails
    else
      puts "Exiting.\n\n"
      exit! # abort script
    end
  end

  def launch
    introduction
    # action loop
    result = nil #? default values?
    # what do you want to do (list, find, add, quit)
    until result == :quit #? loop, do loop, geting input in or outside, until vs while; # ? use if symbol?; what type used as checking values?
      action, args = get_action
      result = do_action(action, args)
    end
    conclusion
  end

  #? doing this as a function? -- allows to add some checking without cluttering launch method
  # get action (user's input, and check whether/make sure its a valid action before sending it to do_action method
  def get_action
    #? default values
    action = nil
    #? need Guide:: ?
    until Guide::Config.actions.include?(action)
      puts "Actions: ", Guide::Config.actions.join(", ") if action != nil
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(" ")
      action = args.shift
    end
    return action, args
  end

  # handles action given by user
  def do_action(action, args=[])
    # we know what the actions are going to be beforehand
    case action
    when "list"
      list(args)
    when "find"
      #puts "Finding..."
      keyword = args.shift #? bad to make these type of 'tmp' variables or semnatic?
      find(keyword)
    when "add"
      # puts "Adding..."
      # could put code here, but rather use as signpost to say what we gonna do
      add
    when "quit"
      return :quit
    else
      puts "I don't understand that command."
    end
  end

  def find(keyword="")
    output_action_header("Find a restaurant")
    if keyword
      restaurants = []
      #? could have used select...better?
      Restaurant.saved_restaurants.each do |rest|
        if rest.name.downcase.include?(keyword.downcase) || rest.cuisine.downcase.include?(keyword.downcase) || rest.price.to_i <= keyword.to_i
          restaurants << rest
        end
      end
      output_restaurant_table(restaurants)
    else
      puts "Find using a keyphrase to search the restaurant list"
      puts "Example: find mexican"
    end
  end

  #? separate functions
  #? args as a name
  def list(args=[]) #? if you give a function like this nil, what will sort_term be

    #? as a strat?
    # to allow for inputs closer to english, allow user to use word by. Instead of re-writing lots, just add anotehr line (a)
    sort_order = args.shift
    sort_order = args.shift if sort_order == "by" # line (a)
    #sort_order ||= "name"
    sort_order = "name" unless ['name','price','cuisine'].include?(sort_order)

    #instead of like below, put case statement IN sort
    #? should you have an else even if you've made sure that it can only tak eon certain values
    restaurants = Restaurant.saved_restaurants
    restaurants.sort! do |r1,r2|
      case sort_order
      when "name"
        r1.name.downcase <=> r2.name.downcase
      when "cuisine"
        r1.cuisine.downcase <=> r2.cuisine.downcase
      when "price"
        r1.price.to_i <=> r2.price.to_i
      end
    end
    output_restaurant_table(restaurants)

    # output_action_header("Listing restaurants")
    # restaurants = []
    # case sort_order
    # when "cuisine"
    #   restaurants = Restaurant.saved_restaurants.sort {|r1,r2| r1.cuisine.downcase <=> r2.cuisine.downcase}
    #   #restaurants = Restaurant.saved_restaurants.sort {|rest| rest.cuisine.downcase}
    # when "price"
    #   restaurants = Restaurant.saved_restaurants.sort {|r1,r2| r1.price.to_i <=> r2.price.to_i }
    # when "name" #, "", nil
    #   restaurants = Restaurant.saved_restaurants.sort {|r1,r2| r1.name.downcase <=> r2.name.downcase}
    # else
    #   puts "List using the name, cuisine, or price of the restaurant."
    #   puts "Examples: list price, list cuisine"
    # end
    # output_restaurant_table(restaurants)
  end

  #? hash way of doing this? -- moved to Restaurant
  def add
    output_action_header("Add a restaurant")

    ## moved out of guide to restaurant, but as a class method ?
    # #?
    # args = {}
    #
    # print "Restaurant name: "
    # args[:name] = gets.chomp.strip
    # print "Restaurant cuisine type: "
    # args[:cuisine] = gets.chomp.strip
    # print "Restaurant average price: "
    # args[:price] = gets.chomp.strip
    #
    # restaurant = Restaurant.new(args)

    restaurant = Restaurant.build_using_questions

    #? save new restaurant details to file
    if restaurant.save
      puts "\nRestaurant added."
    else
      puts "\nAdd error: restaurant not added."
    end
  end

  def introduction
    puts "\n\n<< Welcome to the Food Finder >>\n\n"
    puts "This is an interactive guide to help you to find the food you crave.\n\n"
  end

  def conclusion
    puts "\n<< Goodbye and Bon Appetit! >>\n\n\n"
  end

  #private?
  private

  #? name
  def output_action_header(text)
    puts "\n#{text.upcase.center(60)}\n\n"
  end

  #vs string formatting?
  def output_restaurant_table(restaurants=[])
    puts "-"*60
    print " ","Name".ljust(30)," ", "Cuisine".ljust(20)," ", "Price".rjust(6),"\n"
    puts "-"*60

    restaurants.each do |rest| #? abbreviations?
      table_line = " " + rest.name.titleize.ljust(30) + " " + rest.cuisine.titleize.ljust(20) + " " + rest.formatted_price.rjust(6)
      puts table_line
    end

    puts "No listings found" if restaurants.empty?
    puts "-"*60

  end
end

















## end guide.rb ##
