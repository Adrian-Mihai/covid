class CreateDistrictReports < ActiveRecord::Migration[6.1]
  def change
    create_table :district_reports do |t|
      t.belongs_to :district, null: false, foreign_key: true
      t.date :date, null: false, index: { unique: true }
      t.integer :cases

      t.timestamps
    end
  end
end
