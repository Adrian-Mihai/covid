class VaccinationReport < ApplicationRecord
  validates :date, presence: true, uniqueness: true

  belongs_to :country
end
