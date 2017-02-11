# ? The initialize method in the guide takes a path that we sent into it, and tries to find a file located at that path. If it can't find it, it tries to create it. Now we could just put that functionality right there in the initialize method. But that's not the best option. It's not as object-oriented as it could be. Instead, it's going to be much better to have a restaurant class and put all of the functionality of dealing with that data file in the restaurant class.

require 'support/number_helper' #? dependency
# require 'support/string_helper' #? dependency

class Restaurant

  include NumberHelper

  # where place these?
  attr_accessor :name, :cuisine, :price

  #? better but still helpful way of doing the filepath?
  @@filepath = nil

  def self.filepath=(path=nil)
    # requires that path be relative to APP_ROOT
    @@filepath = File.join(APP_ROOT, path)
  end

  #? is there a point to having this in a methof as opposed to just doing the check in Guide class?
  #? best way to do these predicat methods?
  def self.file_exists?
    # class should know if the restaurant file exists
    # ?[first cond necessary] has it been set && if you got into the file system, is it there
    if @@filepath && file_usable?
      return true
    else
      return false
    end
  end

  # ?[best&reable way] expansion of previous method and using a differnt way
  # ? and unless vs if
  def self.file_usable?
    # all reasons it might fail
    return false unless @@filepath
    return false unless File.exist?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end

  def self.create_file
    # create the restaurant file
    File.open(@@filepath, "w") unless file_exists? # will create file if doesn't exist
    return file_usable?
  end

  #??  One other consideration that I want to point to you here is that when we are designing this method, we also have to ask ourselves if we want to get a fresh copy of these restaurant each time, do we want to go back to the file system and reload whatever is there? Or do we want to store these results in a variable, so that they are now booted one time, and we never need to check again? In that case, we could turn this into let's say @restaurants, right? And we could check to see if it had been set already or not. I am going to have it so that it actually reads every time. That way maybe if there's more than one person working on this file, or if we change the file by actually going into the file and typing something, we will get a fresh copy each and every time. So, just consider that about this saved_restaurants method.
  #?? work from array and write later?
  def self.saved_restaurants
    restaurants = []
    # read the restaurant file
    #?
    if file_usable?
      File.open(@@filepath,"r") do |file|
        file.each_line do |line|
          #self.new({name: line_array[0], cuisine: line_array[1], price: line_array[2]})
          restaurants << Restaurant.new.import_line(line.chomp) #Restaurant.new returns a new restaurant, so we need impoty_line to return that instance so return self
        end
      end
    # could have some logic which says error about retrieving restaurants
    end
    # return instances of restaurant
    return restaurants # will return empty if logic above not work
  end

  # asking user input in restaurant class?
  # want retausrnt class to 'know' how to get input?
  def self.build_using_questions
    #?
    args = {}

    print "Restaurant name: "
    args[:name] = gets.chomp.strip
    print "Restaurant cuisine type: "
    args[:cuisine] = gets.chomp.strip
    print "Restaurant average price: "
    args[:price] = gets.chomp.strip

    # restaurant = Restaurant.new(args)
    return self.new(args) #? self => always refers to the class? ; self better than Restaurant? why can't just saw "new()"?
  end

  #? better way? my way?
  #? problem with symbol names again? or okay cuz you know? ; see self.build_using_questions & import_line for how this is handled #?
  def initialize(args={})
    # could have problem where everything blank, or you could make save fail if not have an attribute
    #? formatting below?
    @name     = args[:name]     || ""
    @cuisine  = args[:cuisine]  || ""
    @price    = args[:price]    || ""
  end

  #! instance method
  #? at the point this is called, we are in an anonymous new Restaurant so can use instance variables
  #? best/better way?
  def import_line(line)
    line_array = line.split("\t") #? name

    # destructuring
    @name, @cuisine, @price = line_array

    return self # returns the OBJECT
  end

  # could just have one line here: File.open...; bt then is there a point to the method? or will it return an error
  def save
    return false unless Restaurant.file_usable? #? better way? need to do given next line will return false if need be?..or will it return an error
    File.open(@@filepath,"a") do |file|
      file.puts "#{[@name, @cuisine, @price].join("\t")}\n" #? better way?
    end
    return true
    # if ...
    #   return true
    # else
    #   return false
    # end
  end

  def formatted_price
    return number_to_currency(@price)
    # return number_to_currency(@price,{unit: "R", precision: 10, delimeter: "\'", separator: "[separator]"})
  end

  # one methd that takes in string
  # @ or no @?
  # here or guide?
  # def formatted_name
  #   return name.titleize
  # end
  #
  # def formatted_cuisine
  #   return @cuisine.titleize
  # end

end
