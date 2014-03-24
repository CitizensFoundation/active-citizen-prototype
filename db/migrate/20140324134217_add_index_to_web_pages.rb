class AddIndexToWebPages < ActiveRecord::Migration
  def change
    add_index :web_pages, :url
    add_index :web_pages, :title
  end
end
