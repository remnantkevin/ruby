require 'date'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.open('bleeter.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'mtom.db'
)



class User < ActiveRecord::Base
  has_many :bleets
end



class BleetTag < ActiveRecord::Base
  belongs_to :bleet
  belongs_to :tag
end

class Tag < ActiveRecord::Base
  has_many :bleet_tags
  has_many :bleets, through: :bleet_tags
end

class Bleet < ActiveRecord::Base
  #? where these two go?
  belongs_to :user
  has_many :bleet_tags
  has_many :tags, through: :bleet_tags

  validates :message, length: {maximum: 160}

  # where go in relation to validates?
  # use blocks instead?: rails says use block if cde fits on one line
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
      # set_attribute(:bleeted_at, "hi")
      # update_attribute(:bleeted_at, "hi")
      self.bleeted_at = DateTime.now
      #@bleeted_at = DateTime.now
    end


  # def initialize(user, message)
  #   @user = user
  #   @message = message
  #   @bleeted_at = DateTime.now
  # end

end

#why in function?
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
    user: user, #why obj and not number? does it 'pick out' the pk_id?
    message: 'this is my first bleet'
  )
end

def more_bleets
  Bleet.create(
    user: user,
    message: "second bleet"
  )
  Bleet.create(
    user: user,
    message: "third bleet"
  )
  Bleet.create(
    user: user,
    message: "fourth bleet"
  )
end

def tags
  Tag.create(word: "second")
  Tag.create(word: "fourth")
end
