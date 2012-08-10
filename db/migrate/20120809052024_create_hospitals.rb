class CreateHospitals < ActiveRecord::Migration
  def change
    create_table :hospitals do |t|
      t.string :name
      t.string :location_city
      t.string :location_area
      t.float :location_logitude
      t.float :location_latitude
      t.text :detail

      t.timestamps
    end
  end
end
