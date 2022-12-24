class Area < ApplicationRecord
  has_many :histories, :dependent => :destroy
end
