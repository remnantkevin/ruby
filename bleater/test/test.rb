# p Dir["./*.rb"]
# p Dir["/home/kevin/webdev/ruby/bleater/test/*.rb"]
# # Dir['./'].each {|filename| require filename
# # Bleater::User.new(first_name: 'Kevin', last_name: 'Elliott', username: 'kevell', email: 'skim@gmail.com', password: 'silent')
require 'active_record'
Dir.entries(Dir.pwd).each do |filename|
  if filename =~ /^.+\.rb$/ && filename !=~ /.*bleater.*/
    require_relative filename #.sub!('.rb', '')
  end
end

ActiveRecord::Base.logger = Logger.new(File.open(Dir.pwd + '/bleater.log', 'w'))

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => Dir.pwd + '/test.db'
)

def setup
  user1 = Bleater::User.create(first_name: 'Kevin', last_name: 'Elliott', username: 'kevell', email: 'skim@gmail.com', password: 'Silent!123')
  user2 = Bleater::User.create(first_name: 'Roland', last_name: 'Elliott', username: 'rolell', email: 'rol@gmail.com', password: 'Silent!123')
  user3 = Bleater::User.create(first_name: 'Laurie', last_name: 'Scarbs', username: 'laurie', email: 'ls@gmail.com', password: 'Silent!123')

  user = Bleater::User.find_by_username('kevell')
  user.bleats << Bleater::Bleat.new(message: 'hello there this is my forst tweet by kevell')
  user.save
end

def do_action

  # get user who bleated
  user = Bleater::User.find_by_username('kevell')
  p user

  # get text of bleat
  new_bleat_text = 'im so #happy that i get to see #johnwick2 on #friday' #what if same tag twice
  p new_bleat_text

  # user.bleats << Bleater::Bleat.new(message: new_bleat_text) #? could you create a new bleat without any other infor but still add to its tags and when you add it to a user and aave, it will fill in the relevant bleat-id:tag-id pairs?
  # create new bleat
  b = Bleater::Bleat.new(message: new_bleat_text)
  p b

  # extract only text from bleat, i.e. without hash at beginning
  tags = new_bleat_text.scan(/\#\w+/).map do |tag_text|
    tag_text.delete('#') #? should it be saved without the #?
  end
  p tags

  #? more detail in comment -- if false etc.
  # for each tag extracted, either add the corresponding tag to the current bleat, or create a new tag and add it to the current bleat
  tags.each do |tag_text|
    # second time tag appears in bleat
    # tag exists
    if Bleater::Tag.exists?(word: tag_text)
      # user.bleats.last.tags <<
      b.tags << Bleater::Tag.find_by_word(tag_text)
      p "#{tag_text} tag exists"
    else # tag doesn't exist
      # create new tag and attach to bleat
      b.tags << Bleater::Tag.new(word: tag_text)
      p "#{tag_text} tag doesn't exists"
    end
  end
  p b.tags

  # assign the new bleat to the user and save -- intermediary attribute (e.g. ids) created for the tags and bleat when user is saved
  user.bleats << b
  p user.bleats
  user.save

end
