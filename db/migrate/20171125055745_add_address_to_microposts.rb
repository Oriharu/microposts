class AddAddressToMicroposts < ActiveRecord::Migration[5.0]
  def change
    add_column :microposts, :address, :string
  end
end
