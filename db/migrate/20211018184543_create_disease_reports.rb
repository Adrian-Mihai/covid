class CreateDiseaseReports < ActiveRecord::Migration[6.1]
  def change
    create_table :disease_reports do |t|
      t.belongs_to :country, null: false, foreign_key: true
      t.date :date, null: false, index: { unique: true }
      t.integer :cases
      t.integer :tests
      t.integer :deaths
      t.integer :recovered
      t.integer :intensive_care
      t.integer :hospitalized
      t.integer :emergency_calls
      t.integer :information_calls
      t.integer :home_isolation
      t.integer :home_quarantine
      t.integer :institutional_isolation
      t.integer :institutional_quarantine

      t.timestamps
    end
  end
end
