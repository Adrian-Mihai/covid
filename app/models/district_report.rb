class DistrictReport < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :cases, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

  belongs_to :district
end
