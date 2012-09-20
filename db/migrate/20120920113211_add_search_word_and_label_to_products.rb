class AddSearchWordAndLabelToProducts < ActiveRecord::Migration
  def change
    add_column :products, :search_word, :string, default: nil
    add_column :products, :label, :string, default: nil
  end
end
