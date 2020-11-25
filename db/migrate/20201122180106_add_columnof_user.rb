class AddColumnofUser < ActiveRecord::Migration[6.0]
  def change
  	add_column :users, :link_albums, :string, array: true, default: []
  end
end
