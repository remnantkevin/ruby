require 'active_record'

module Bleater
  class User < ActiveRecord::Base
    has_one :alias
    has_many :bleats, dependent: :destroy

    validates :password, length: {minimum: 8}

    after_create :add_alias
    before_destroy :remove_alias #? this not done auto?

    private
      def add_alias
        self.alias = Alias.create(user_id: self.user_id) #? will this create the PK and FK? No. Why can;t it infer the user_id (FK) like the bleat did when adding a bleat to a user
      end

      # this should be done as I did above with [dependent: :destroy]
      def remove_alias
        puts "** #{self.to_s} deleted **"
        self.alias.destroy #? better way? originally has self.alias = nil, but then an update error would occur when trying to set the alias obj/record without a user_id. is the update method called when using =?
      end

  end
end
