# require 'active_record' #here or in all model files? or both?
# #Dir["./bleater/*.rb"].each {|file| require file}
# require './bleater/user'
# require './bleater/bleat'
# require './bleater/tag'
# require './bleater/bleat_tag'
#
# ActiveRecord::Base.logger = Logger.new(File.open('./database/bleater.log', 'w'))
#
# ActiveRecord::Base.establish_connection(
#   :adapter  => 'sqlite3',
#   :database => './database/bleater.db'
# )
#
#
#
#
# u = Bleater::User.create(first_name: 'Kevin', last_name: 'Elliott', email: 'skiimilk@gmail.com', password: 'silent123', username: 'remnant')

require './bleater/bleater'

b = Bleater::Bleater.new()
b.launch
