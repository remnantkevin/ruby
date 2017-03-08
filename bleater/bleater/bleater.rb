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
        puts
        puts '1. Login'
        puts '2. Sign up'
        puts '3. View all Bleater users'
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
        puts "\n==== Login ===="
        login_form
      when '2'
        puts "\n==== Signup ===="
        signup_form
      when '3'
        puts "\n==== Users ===="
        view_users
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

    def signup_form
      puts 'Fill in your details below to create a Bleater account.'
      puts '----'
      print "\n1) Name: "
      name = gets.chomp.strip #just strip?
      while valid_signup_form_input?(name, :n)
        puts "\nThe name you entered is not valid, it must be at least one character long and can only contain letters and dashes [for example, Kev-in]. Please try again."
        print 'Name: '
        name = gets.chomp.strip
      end
      print "\n2) Surname: "
      surname = gets.chomp.strip
      while valid_signup_form_input?(surname, :s)
        puts "\nThe surname you entered is not valid, it must be at least one character long and can only contain letters and dashes [for example, Johnson-Barker]. Please try again."
        print 'Surame: '
        surname = gets.chomp.strip
      end
      print "\n3) Email: "
      email = gets.chomp.strip
      while valid_signup_form_input?(email, :e)
        puts "\nThe email address you entered is already in use or is not valid. An example of a valid email address is the following: skiimilk@gmail.com. Please try again.\n"
        print 'Email: '
        email = gets.chomp.strip
        #how would you end the method and input if they typed in exit for email?
      end
      # p email
      print "\n4) Username: "
      username = gets.chomp.strip
      while valid_signup_form_input?(username, :u)
        puts "\nThe username you entered is already in use or not valid. Usernames must be netween 5 and 15 characters long, and can contain only alphabetic characters and underscores. For example, rem_nant. PLease try again."
        print 'Username: '
        username = gets.chomp.strip
      end
      print "\n5) Password: "
      password = gets.chomp
      while valid_signup_form_input?(password, :p)
        puts "\nYour password must be between 8 and 15 characters long, and contain one capital, one lowercase, and one numeric character [for example, 'Pools123']. Your password can also conatin the special characters _!&$#."
        print 'Password: '
        password = gets.chomp
      end
      signup(name, surname, email, username, password)
    end

    # would there be a better way of doing this function where you could go input.valid.....?
    def valid_signup_form_input?(input, type)
      # reason to do this with not symbols or vv?
      # better to use =~ somehow?
      case type
      when :n, :s
        !input.match(/^[[:alpha:]\- ]+$/)
      when :e
        !input.match(/^[\w.]+@\w+(\.[[:alpha:]]+){1,2}$/) || User.exists?(email: input)
      when :u
        !input.match(/^\w{5,15}$/) || User.exists?(username: input)
      when :p
        !input.match(/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[\w\$!#&]{8,15}$/)
      else
        puts "## wrong input type ##"
        # how do this for the programmer?
      end
    end

    def signup(name, surname, email, username, password)
      # have to be in column order?
      # !! what if fail?
      User.create(first_name: name, last_name: surname, email: email, username: username, password: password)
      puts "\nAccount created. Welcome to Bleater! Login to use Bleater\n"
    end

    # !! use same one with optional input for viewing one or many
    # always select in same order twice if no change to db?
    def view_users
      # get all user so can interact after viewing them? all_users
      User.select(:username).each_with_index {|user, index| puts "#{index+1}. #{user.username}"}
    end

  end
end
