require 'active_record' #here or in all model files? or both?
Dir["./bleater/*.rb"].each {|file| require file}
# require './bleater/user'
# require './bleater/bleat'
# require './bleater/tag'
# require './bleater/bleat_tag'

module Bleater
  class Bleater

    # store current user as instance varibale? or pass it along tghrough methods when needed?
    attr_accessor :current_user

    # why is this run from where init.rb is?
    def initialize
      #p Dir["*.rb"]
      # do these exist beyond the scope of this init function?
      ActiveRecord::Base.logger = Logger.new(File.open('/home/kevin/webdev/ruby/bleater/database/bleater.log', 'w'))

      ActiveRecord::Base.establish_connection(
        :adapter  => 'sqlite3',
        :database => '/home/kevin/webdev/ruby/bleater/database/bleater.db'
      )

    end

    def launch
      #p Dir["*.rb"]
      introduction
      # action loop
      input = nil
      while true
        puts '1. Login'
        puts '2. Sign up'
        puts 'Q. Quit'
        print '> '
        input = gets.chomp
        if input == 'q' || input == 'Q' || input == 'quit' || input == 'Quit'
          puts 'Quitting ...'
          break
        end
        do_action(input)
      end
      # conclusion
    end

    def introduction
      #p Dir["./bleater/*.rb"]
      puts "==== Bleater ====\n"
      puts "Welcome to Bleater! What would you like to do?\n"
    end

    def do_action(action)
      # p "action: #{action}"
      case action
      when '1'
        puts "==== Login ===="
        login_form
      when '2'
        puts "==== Signup ===="
        signup_form
      end
    end

    def login_form
      # regex/form check
      print 'username: '
      username = gets.chomp
      print 'password: '
      password = gets.chomp
      # current_user = 2
      # p login_user(username, password)
      if login_user(username, password)
        # puts "===="
        # puts current_user
        # puts "===="
        puts "Welcome #{current_user.first_name}. Logging in ..."
      else
        puts 'Username and password combination not valid. Try again or signup.'
      end
    end

    # order?
    def login_user(username, password)
      #find by?
      username = 'remnant'
      password = 'silent123'
      # don't need bleater:: cuz in same module?
      # self.current_user = User.where(username: username, password: password).take
      self.current_user = User.find_by(username: username, password: password) # a User object or nil if not found
      # p current_user
      # return true
    end

    def singup_form
      puts 'Fill in your details below to create a Bleater account'
      print 'Name: '
      print 'Surname: '
      print 'Email: '
      email =
      while !regex || User.email.exists
        puts 'That email is already in use. Try another.'
        print 'Email: '
        email =
      end
      print 'Username: '
      # same for username as for email
      print 'Password: '
      password = gets.trim.chomp
      #better way to use regex?
      unless password.match('regex')
        puts "Your password must be 8-15 characters long, with one capital, one lowercase, and one numeric character [for example, 'Pools123']"
        print 'Password: '
        password = gets.trim.chomp
      end
      if signup(name, surname, email, username)
    end

    def signup

    end

  end
end
