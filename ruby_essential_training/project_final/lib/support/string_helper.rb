# This helper class is opening up core Ruby String class in order to add a new method to all strings
#? ??
class String

  # Ruby has a capitalise method which capitalises the first letter of a string. But in order to capitalise the first letter of each word of a string, we have to write our own method.
  def titleize
    #! self
    self.split(" ").map { |word| word.capitalize }.join(" ") #w/o join, returns array
  end



end
