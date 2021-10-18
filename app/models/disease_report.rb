class DiseaseReport < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :cases, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :tests, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :deaths, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :recovered, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :intensive_care, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :hospitalized, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :emergency_calls, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :information_calls, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :home_isolation, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :home_quarantine, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :institutional_isolation, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true
  validates :institutional_quarantine, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

  belongs_to :country
end
