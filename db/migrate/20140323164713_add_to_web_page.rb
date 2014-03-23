class AddToWebPage < ActiveRecord::Migration
  def change
    add_column :web_pages, :title, :string
    add_column :web_pages, :screenshot_file_name, :string
    add_column :web_pages, :screenshot_file_size, :integer
    add_column :web_pages, :screenshot_content_type, :string
    add_column :web_pages, :screenshot_updated_at, :datetime
  end
end
