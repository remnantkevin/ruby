require 'active_record'

module Bleater
  class Tag < ActiveRecord::Base
    has_many :bleat_tags
    has_many :bleats, through: :bleat_tags
  end
end
