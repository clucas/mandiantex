class CreateMediaItems < ActiveRecord::Migration
  def change
    create_table :media_items do |t|
      t.string :title, :null => false
      t.string :author, :null => false
      t.string :publisher, :null => false
      t.string :published_on
      t.integer :unit_cost, :null => false, :default => 0
      t.string :category, :null => false
      t.string :currency

      t.timestamps
    end 
    add_index :media_items, [:title, :author, :publisher, :published_on], :name => "media_items_unique_index", :unique => true
  end
end
