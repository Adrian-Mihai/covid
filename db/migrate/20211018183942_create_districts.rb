class CreateDistricts < ActiveRecord::Migration[6.1]
  def change
    create_table :districts do |t|
      t.belongs_to :country, null: false, foreign_key: true
      t.string :name, null: false
      t.string :code, null: false, index: { unique: true }
      t.integer :population, null: false, default: 0

      t.timestamps
    end
  end
end
