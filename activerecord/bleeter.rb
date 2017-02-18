require 'date'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.open('bleeter.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'bleeter.db'
)

class User <  ActiveRecord::Base
  has_many :bleets
end

class Bleet < ActiveRecord::Base
  belongs_to :user

  validates :message, length: {maximum: 160}
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
    message: 'this is my first bleet',
    bleeted_at: DateTime.now
  )
end
