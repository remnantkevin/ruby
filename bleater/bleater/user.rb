require 'active_record'

module Bleater
  class User < ActiveRecord::Base
    has_and_belongs_to_many :bleats

    validates :password, length: {minimum: 8}
  end
end
