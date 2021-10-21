class FixIndexOnResources < ActiveRecord::Migration[6.1]
  def change
    remove_index :vaccination_reports, :date
    remove_index :disease_reports, :date
    remove_index :district_reports, :date

    add_index :vaccination_reports, %i[date country_id], unique: true
    add_index :disease_reports, %i[date country_id], unique: true
    add_index :district_reports, %i[date district_id], unique: true
  end
end
