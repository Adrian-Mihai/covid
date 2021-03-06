class District < ApplicationRecord
  before_validation :sanitize_code

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :population, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  belongs_to :country

  private

  def sanitize_code
    return if code.nil?

    code.strip!
    code.upcase!
  end
end
