class ChangeColumnName < ActiveRecord::Migration[6.0]
  def change
  	rename_column :users, :countries, :country
  end
end
