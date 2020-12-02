class AddPlaylistToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :communities, :playlist, :string
  end
end
