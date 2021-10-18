class CreateVaccinationReports < ActiveRecord::Migration[6.1]
  def change
    create_table :vaccination_reports do |t|
      t.belongs_to :country, null: false, foreign_key: true
      t.date :date, null: false, index: { unique: true }
      t.jsonb :vaccine, null: false, default: {}
      t.jsonb :side_effect, null: false, default: {}


      t.timestamps
    end
  end
end
