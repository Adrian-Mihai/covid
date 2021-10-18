class Overview < ApplicationRecord
  validates :cases, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :tests, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :deaths, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :recovered, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :vaccinated, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :side_effect, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

  belongs_to :country
end
