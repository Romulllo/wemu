class AddNameAndDescriptionToCommunities < ActiveRecord::Migration[6.0]
  def change
    add_column :communities, :name, :string
    add_column :communities, :description, :text
  end
end
