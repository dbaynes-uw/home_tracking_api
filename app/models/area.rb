class Area < ApplicationRecord
  has_many :tasks, :dependent => :destroy
end
