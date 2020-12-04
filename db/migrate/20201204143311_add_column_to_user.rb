class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_songs_identifiers, :string, array: true, default: []
  end
end
