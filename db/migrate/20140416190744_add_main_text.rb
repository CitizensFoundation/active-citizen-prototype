class AddMainText < ActiveRecord::Migration
  def change
    add_column :web_pages, :main_text, :text
  end
end
