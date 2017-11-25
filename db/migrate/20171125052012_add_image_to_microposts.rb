class AddImageToMicroposts < ActiveRecord::Migration[5.0]
  def change
    add_column :microposts, :image, :string
  end
end
