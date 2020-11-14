class AddTitleToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :communities, :Title, :string
  end
end
