class DropTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :disease_reports
    drop_table :district_reports
    drop_table :vaccination_reports
  end
end
