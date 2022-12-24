class History < ApplicationRecord
  belongs_to :area, class_name: 'Area', foreign_key: 'area_id'
end
