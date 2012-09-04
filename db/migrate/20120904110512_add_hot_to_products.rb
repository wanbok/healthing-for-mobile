class AddHotToProducts < ActiveRecord::Migration
  def change
    add_column :products, :hot, :boolean, default: false
    
  end
end
