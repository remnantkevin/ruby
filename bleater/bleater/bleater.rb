require 'active_record' #here or in all model files? or both?
#Dir["./bleater/*.rb"].each {|file| require file}
require './bleater/user'
require './bleater/bleat'
require './bleater/tag'
require './bleater/bleat_tag'

module Bleater
  class Bleater

    # store current user as instance varibale?
    attr_accessor :current_user

    def initialize

      # do these exist beyond the scope of this init function?
      ActiveRecord::Base.logger = Logger.new(File.open('/home/kevin/webdev/ruby/bleater/database/bleater.log', 'w'))

      ActiveRecord::Base.establish_connection(
        :adapter  => 'sqlite3',
        :database => '/home/kevin/webdev/ruby/bleater/database/bleater.db'
      )

    end

    def launch
      introduction
      # action loop
      input = nil
      while input != 'quit'
        puts '1. Login'
        puts '2. Sign up'
        print '> '
        input = gets.chomp
        do_action(input)
      end
      # conclusion
    end

    def introduction
      puts "==== Bleater ====\n"
      puts "Welcome to Bleater! What would you like to do?\n"
    end

    def do_action(action)
      p "action: #{action}"
      p action == 1
      case action
      when 'quit'
        puts 'Quiting ...'
      when '1'
        login
      when 2
        signup
      end
    end

    def login
      # regex/form check
      print 'username: '
      username = gets.chomp
      print 'password: '
      password = gets.chomp
      # current_user = 2
      if login_user(username, password)
        puts "===="
        puts current_user
        puts "===="
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
      self.current_user = User.where(username: username, password: password).take
      p current_user
      return true
    end

    def signup

    end

  end
end
