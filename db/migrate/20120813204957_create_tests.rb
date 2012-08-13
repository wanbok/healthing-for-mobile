class CreateTests < ActiveRecord::Migration
  def change
    create_table :hospitals do |t|
      t.string :name
			t.string :location_city
			t.string :location_area
			t.float :location_latitude
			t.float :location_logitude
			t.string :tel_number
			t.string :department
			t.string :detail

      t.timestamps
    end

    create_table :products do |t|
    	t.integer :hospital_id
      t.string :name
			t.integer :price
			t.float :dc_rate
			t.datetime :event_start_at
			t.datetime :event_end_at
			t.integer :read_count, default: 0
			t.integer :favorite_count, default: 0

      t.timestamps
    end

    create_table :photos do |t|
    	t.integer :hospital_id
    	t.integer :product_id
      t.attachment :image
    end

    create_table :users do |t|
      t.string :udid

      t.timestamps
    end

    create_table :products_users, id: false do |t|
      t.integer :product_id
      t.integer :user_id
    end
  end
end