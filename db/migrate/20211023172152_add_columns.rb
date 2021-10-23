class AddColumns < ActiveRecord::Migration[6.1]
  def change
    add_column :countries, :payload, :jsonb, null: false, default: {}
    add_column :districts, :payload, :jsonb, null: false, default: {}
  end
end
