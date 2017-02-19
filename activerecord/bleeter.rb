require 'date'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.open('bleeter.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'test2.db'
)

class User < ActiveRecord::Base
  has_many :bleets
end

class Bleet < ActiveRecord::Base
  #? where these two go?
  belongs_to :user
  validates :message, length: {maximum: 160}

  # where go in relation to validates?
  # use blocks instead?
  # after_initialize :after_initialize
  before_save :before_save

  # The after_initialize callback is triggered every time a new object of the class is initialized.
  # if you wanna mess around with a bleet before saving it then this wouldn't work; but it also wouln't work whenever you read and store from the db cuz .new will be called
  # private
  #   def after_initialize
  #     p 'Hello there'
  #   end

  private
    def before_save
      p 'hello'
      # how do this from within model as opposed to in running part of file?
      @bleeted_at = "hi"
    end


  # def initialize(user, message)
  #   @user = user
  #   @message = message
  #   @bleeted_at = DateTime.now
  # end

end

def user
  @user ||= if User.any?
    User.first
  else
    User.create(
      first_name: 'Kevin',
      last_name: 'Elliott',
      email: 'thisismyemail@gmail.com',
      username: 'remnant'
    )
  end
end

def bleet
  @bleet ||= Bleet.new(
    user: user,
    message: 'this is my first bleet'
  )
end
