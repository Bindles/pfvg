class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :handle
      t.string :name
      t.float :price
      t.float :retail_price
      t.text :description
      t.string :category
      t.string :path
      t.string :default_image_url
      t.string :currency
      t.integer :entity_id

      t.timestamps
    end
  end
end
