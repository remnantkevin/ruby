require 'active_record'
module Bleater

  class Alias < ActiveRecord::Base

    has_and_belongs_to_many :bleats
    belongs_to :user

  end

end
