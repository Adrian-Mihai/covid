class VaccinationReport < ApplicationRecord
  validates :date, presence: true, uniqueness: { scope: :country_id }

  belongs_to :country
end
