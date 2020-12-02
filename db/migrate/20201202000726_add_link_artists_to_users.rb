class AddLinkArtistsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :link_artists, :string, array: true, default: []
  end
end
