require 'active_record'

module Bleater
  class BleatTag < ActiveRecord::Base
    belongs_to :bleat
    belongs_to :tag
  end
end
