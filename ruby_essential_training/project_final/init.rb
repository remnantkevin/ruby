### Food Finder ###

# puts __FILE__
# puts __dir__ #absolute
# puts File.dirname(__FILE__) #relative

APP_ROOT = __dir__

# require "#{APP_ROOT}/lib/guide"
# puts File.join(APP_ROOT,"lib", "guide")

# special variable in ruby that contains an array of all the folders that Ruby will look in to find the files that we've asked for
# p $:
#=> ["/usr/local/lib/site_ruby/2.4.0", "/usr/local/lib/x86_64-linux-gnu/site_ruby", "/usr/local/lib/site_ruby", "/usr/lib/ruby/vendor_ruby/2.4.0", "/usr/lib/x86_64-linux-gnu/ruby/vendor_ruby/2.4.0", "/usr/lib/ruby/vendor_ruby", "/usr/lib/ruby/2.4.0", "/usr/lib/x86_64-linux-gnu/ruby/2.4.0"]

$: << File.join(APP_ROOT,"lib")
# p $:

require 'guide'
# The guide class really is going to be the heart of the food finder, because in that init.rb file, we are going to instantiate the guide class. We are going to create a new guide, right, a new instance of the guidebook. And then we will tell that guidebook, hey, guidebook take over, and at that point the guide class will take over, and it will handle all of the user input, and do all the processing of the actions that have been asked for, and handle the user output as well. So really the guide class is going to be the controller class. It is going to control what's going on.

# seems weird (cf. Java) if only ever going to have one Guide
guide = Guide.new('restaurants.txt')
guide.launch






















## end init.rb ##
