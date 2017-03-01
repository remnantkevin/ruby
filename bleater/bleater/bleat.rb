require 'date'
require 'active_record'

module Bleater
  class Bleat < ActiveRecord::Base
    #? where these two go?
    belongs_to :user
    has_many :bleat_tags
    has_many :tags, through: :bleat_tags

    validates :message, length: {maximum: 160}

    # where go in relation to validates?
    # use blocks instead?: rails says use block if cde fits on one line
    # after_initialize :after_initialize
    before_save :before_save

    private
      def before_save
        self.bleated_at = DateTime.now

      end

  end
end
