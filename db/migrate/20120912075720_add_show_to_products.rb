class AddShowToProducts < ActiveRecord::Migration
  def change
    add_column :products, :show, :boolean, default: true
  end
end
