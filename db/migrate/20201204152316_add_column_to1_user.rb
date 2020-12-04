class AddColumnTo1User < ActiveRecord::Migration[6.0]
  def change
   add_column :users, :link_album_top_artists, :string, array: true, default: []
  end
end
