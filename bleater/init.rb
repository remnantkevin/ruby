require 'active_record' #here or in all model files? or both?
Dir["./bleater/*.rb"].each {|file| require file}

ActiveRecord::Base.logger = Logger.new(File.open('bleater.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => './database/bleater.db'
)

u1 = Bleater::User.create(first_name: 'Kevin', last_name: 'Elliott', email: 'skiimilk@gmail.com', password: 'silent', username: 'remnant')

p u1
