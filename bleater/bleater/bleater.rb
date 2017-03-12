require 'active_record' #here or in all model files? or both?
Dir["./bleater/*.rb"].each {|file| require file} # why is this run from where init.rb is?
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


      #? what inital set to?
      @current_user = nil

      # do these exist beyond the scope of this init function?
      ActiveRecord::Base.logger = Logger.new(File.open('/home/kevin/webdev/ruby/bleater/database/bleater.log', 'w'))

      ActiveRecord::Base.establish_connection(
        :adapter  => 'sqlite3',
        :database => '/home/kevin/webdev/ruby/bleater/database/bleater.db'
      )

    end

    def create_users

            User.create(first_name: 'Kevin', last_name: 'Elliott', username: 'kevell', email: 'skim@gmail.com', password: 'Silent!123')
            User.create(first_name: 'Roland', last_name: 'Elliott', username: 'rolell', email: 'rol@gmail.com', password: 'Silent!123')
            User.create(first_name: 'Laurie', last_name: 'Scarbs', username: 'laurie', email: 'ls@gmail.com', password: 'Silent!123')

    end

    def destroy_all_aliases
      Alias.destroy_all
    end

    def launch
      #p Dir["*.rb"]

      # Bleat.create(user_id: 1, message: "hbhbhbhbhb #happybirthday #kevin")

      introduction
      # action loop
      input = nil
      while true
        display_user_loggedin unless current_user == nil
        puts
        puts '0. create users'
        puts '00. destroy aliases'
        puts '1. Login'
        puts '2. Sign up'
        puts '3. Make a bleat'
        puts '4. View all Bleater users'
        puts '5. View bleats by user'
        puts '6. View bleats by tag'
        puts '7. View bleats you are tagged in (requires login)'
        puts '8. View bleats a user is tagged in'
        puts '9. Delete current user account'
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

    def display_user_loggedin
      puts '-'*50
      print ' '*20
      puts "Logged in as: #{current_user.username} | #{Bleat.where(user_id: current_user.user_id).count} "
      puts '-'*50
    end

    def introduction
      #p Dir["./bleater/*.rb"]
      puts "==== Bleater ====\n"
      puts "Welcome to Bleater! What would you like to do?\n"
    end

    def do_action(action)
      # p "action: #{action}"
      case action
      when '0'
        puts "\n==== Creating users ===="
        create_users
      when '00'
        puts "\n==== Destroy aliases ===="
        destroy_all_aliases
      when '1'
        puts "\n==== Login ===="
        login_form
      when '2'
        puts "\n==== Signup ===="
        signup_form
      when '3'
        puts "\n==== Bleat ===="
        make_bleat(make_bleat_form) #? get info back and then ass to function to help readiability?
      when '4'
        puts "\n==== Users ===="
        view_all_users
      when '5'
        puts "\n==== Find bleats by user ===="
        display_bleats_by_user(find_bleats_by_user_form)
      when '6'
        puts "\n==== Find Bleats by Tag ===="
        display_bleats_by_tag(find_bleats_by_tag_form)
      when '7'
        if current_user == nil #? where shd this check go?
          puts "\nPlease login before selecting this option\n"
        else
          puts "\n==== Bleats you are tagged in ===="
          display_bleats_user_tagged_in(current_user)
        end
      when '8'
        puts "\n==== Find bleats a user is tagged in ===="
          display_bleats_user_tagged_in(find_bleats_by_tagged_user_form)
      when '9'
        if current_user == nil #? where shd this check go?
          puts "\nPlease login before selecting this option\n"
        else
          current_user.destroy
          self.current_user = nil #? this not happen auto? no gets set to inactive
        end
      else
        puts "\nNot a valid option. Try again.\n"
      end
    end

    def find_bleats_by_tagged_user_form
      puts "Which username would you like to search bleats for?"
      print 'Username: '
      username = gets.chomp.strip
      while !User.exists?(username: username)
        puts "\nThat username does not exist. Usernames must be between 5 and 15 characters long, and can contain only alphabetic characters, numbers, and underscores. For example, rem_nant. Please try again."
        print 'Username: '
        username = gets.chomp.strip
      end
      return User.find_by_username(username) #? this not un-ruby-like as can't return it otherwise?
    end

    def display_bleats_user_tagged_in(user)
      user.alias.bleats.each do |bleat|
        puts bleat.message
      end
    end

    def make_bleat_form
      puts 'What would you like to say?'
      bleat_text = gets.chomp.strip #? why do functions return the RHS of the last line of the func as opposed to the expression
    end

    #? call bleat? [naming cn=onventions]
    #! assumes only tag actual users?
    def make_bleat(bleat_text)

      #? should i check for user not nil or my code assumes it? if check, what do?

      # create new bleat
      b = Bleat.new(message: bleat_text)

      # extract only text from bleat, i.e. without hash at beginning
      tags = bleat_text.scan(/\#\w+/).map do |tag_text|
        tag_text.delete('#') #? should it be saved without the #?
      end

      #????? should you store PKs or usernames? if user changes username will it change elsehwre?
      aliases = bleat_text.scan(/\@\w+/).map do |user_tag|
        user_tag.delete('@') #? should it be saved without the #?
      end
      #? more detail in comment -- if false etc.
      # for each tag extracted, either add the corresponding tag to the current bleat, or create a new tag and add it to the current bleat
      tags.each do |tag_text|
        # second time tag appears in bleat
        # tag exists
        if Tag.exists?(word: tag_text)
          # user.bleats.last.tags <<
          b.tags << Tag.find_by_word(tag_text)
          # p "#{tag_text} tag exists"
        else # tag doesn't exist
          # create new tag and attach to bleat
          b.tags << Tag.new(word: tag_text)
          # p "#{tag_text} tag doesn't exists"
        end
      end

      p b

      # assign the new bleat to the user and save -- intermediary attribute (e.g. ids) created for the tags and bleat when user is saved
      #? don't 'create' throughout as if something goes wrong nothing shoudl save?
      current_user.bleats << b #!! failed here as it can't know which table to add the bleat to: add it to the bleats table with a FK as userid or add the bleat to the join table
      current_user.save

      p b

      aliases.each do |username|
        user = User.find_by_username(username)
        if user
          user.alias.bleats << b
        else
          puts "\n** @#{username} does not exist, so was not tagged in your bleat **\n"
        end
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
        puts "\nWelcome #{current_user.first_name}. Logging in ...\n"
      else
        puts "\nUsername and password combination not valid. Try again or signup.\n"
      end
    end

    # order?
    def login_user(username, password)
      #find by?
      # username = 'kevell'
      # password = 'Silent!123'
      # don't need bleater:: cuz in same module?
      # self.current_user = User.where(username: username, password: password).take
      user = User.find_by(username: username, password: password) # a User object or nil if not found
      if user # a User object or nil if not found
        self.current_user = user
        true
      else
        false
      end
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
        puts "\nThe username you entered is already in use or not valid. Usernames must be netween 5 and 15 characters long, and can contain only alphabetic characters and underscores. For example, rem_nant. Please try again."
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
      signup_new_user(name, surname, email, username, password)
    end

    # would there be a better way of doing this function where you could go input.valid.....?
    # would this be a validate method?
    def valid_signup_form_input?(input, type)
      # reason to do this with not symbols or vv?
      # better to use =~ somehow?
      case type
      when :n, :s
        !input.match(/^[[:alpha:]\- ]+$/)
      when :e
        !input.match(/^\w+@\w+(\.[[:alpha:]]+){1,2}$/) || User.exists?(email: input) #! \w = [a-zA-Z0-9_]
      when :u
        !input.match(/^\w{5,15}$/) || User.exists?(username: input)
      when :p
        !input.match(/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[\w\$!#&]{8,15}$/)
      else
        puts "## wrong input type ##"
        # how do this for the programmer?
      end
    end

    def signup_new_user(name, surname, email, username, password)
      # have to be in column order?
      # !! what if fail?
      user = User.create(first_name: name, last_name: surname, email: email, username: username, password: password)
      puts "\nAccount created. Welcome to Bleater! You are now logged in.\n"
      self.current_user = user
    end

    # !! use same one with optional input for viewing one or many
    # always select in same order twice if no change to db?
    def view_all_users
      # !! get all user so can interact after viewing them? all_users
      # User.select(:username).each_with_index {|user, index| puts "#{index+1}. #{user.username}"}
      #??????
      User.select(:username).each {|user| puts user.username}
    end

    # should these say display .... for more description?
    def find_bleats_by_user_form
      puts 'Search for bleats made by someone'
      puts '----'
      print 'Username: '
      username = gets.chomp.strip
      # couldnt reuse valid method -- better way? && error message not reused..
      #? the regex is quicker than searching if exists?
      #? seems more efficient to use && in this case as it will stop as soonas one fails...not actually...needs to chec other side of &
      # while !username.match(/^\w{5,15}$/) || !User.exists?(username: username)
      while !(username.match(/^\w{5,15}$/) && User.exists?(username: username))
        puts "\nThat username does not exist. Usernames must be between 5 and 15 characters long, and can contain only alphabetic characters, numbers, and underscores. For example, rem_nant. Please try again."
        print 'Username: '
        username = gets.chomp.strip
      end
      # while true
      #   if
      # end

      #! not just form now -- handled by method that called form method? should the form method return the answer/input
      #? use ifs?
      # display_bleats_by_user(username)
      return username
    end

    #! expand to find similarly names users?
    # def search_for_user(username)
    #   User.find_by(username: username)
    # end

    #? do you still check for nil if somewhere else you've made it not possible to give nil?
    def display_bleats_by_user(username)
        #? is it woth it to select :message and then use where ... instead of fetching all attributes and storing them?
        #? faster/better way of doing the following?
        bleats = Bleat.where(user_id: User.find_by(username: username).user_id) # can't use find_by as that returns the first one
        # p bleats

        #?! am i able to iterate over activerecordrelation becuase its enuerable? look it up. is it somethign that contains an array or is it an array?
        #? is there a way of returning just an array of objects?
        bleats.each do |bleat|
          puts bleat.message
        end

    end

    def find_bleats_by_tag_form
      puts 'Search for bleats with a certain tag'
      puts '----'
      print 'Tag: #'
      tag_text = gets.chomp.strip

      while !(tag_text.match(/^\w+$/) && Tag.exists?(word: tag_text))
        puts "\nThat tag does not exist. Tags must be at least one character long, and can contain only alphabetic characters, numbers, and underscores. For example, 'happy_birthday26'. Please try again."
        print 'Tag: #'
        tag_text = gets.chomp.strip
      end

      return tag_text
    end

    def display_bleats_by_tag(tag_text)
      bleats = Tag.find_by_word(tag_text).bleats

      bleats.each do |bleat|
        puts bleat.message
      end
    end

  end
end
