class AddActive < ActiveRecord::Migration
  def change
    add_column :web_pages, :active, :boolean, :default=>true
  end
end
