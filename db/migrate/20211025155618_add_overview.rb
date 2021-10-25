class AddOverview < ActiveRecord::Migration[6.1]
  def change
    add_column :countries, :overview, :jsonb, null: false, default: {}
    add_column :districts, :overview, :jsonb, null: false, default: {}
  end
end
