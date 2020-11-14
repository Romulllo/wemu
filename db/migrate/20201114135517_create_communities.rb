class CreateCommunities < ActiveRecord::Migration[6.0]
  def change
    create_table :communities do |t|

      t.timestamps
    end
  end
end
