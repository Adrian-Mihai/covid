class CreateOverviews < ActiveRecord::Migration[6.1]
  def change
    create_table :overviews do |t|
      t.belongs_to :country, null: false, foreign_key: true
      t.integer :cases
      t.integer :tests
      t.integer :deaths
      t.integer :recovered
      t.integer :vaccinated
      t.integer :side_effect

      t.timestamps
    end
  end
end
