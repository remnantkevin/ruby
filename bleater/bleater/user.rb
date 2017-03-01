require 'active_record'

module Bleater
  class User < ActiveRecord::Base
    has_many :bleats

    validates :password, length: {minimum: 8}
  end
end
