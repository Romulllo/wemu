class ChangeColumnofUser < ActiveRecord::Migration[6.0]
  def change
  	rename_column :users, :top_artists, :last_artists
  	rename_column :users, :top_songs, :last_songs
  	add_column :users, :last_albums, :string, array: true, default: []
  end
end
