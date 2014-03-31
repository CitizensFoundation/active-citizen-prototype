class CreateWebPageTypes < ActiveRecord::Migration
  def change
    create_table :web_page_types do |t|
      t.string :name
      t.integer :weight
      t.timestamps
    end

    WebPage.connection.schema_cache.clear!
    WebPage.reset_column_information
    WebPageType.connection.schema_cache.clear!
    WebPageType.reset_column_information

    add_index :web_page_types, :name
    add_column :web_pages, :web_page_type_id, :integer
    add_column :web_pages, :active, :boolean, :default=>true

    WebPage.connection.schema_cache.clear!
    WebPage.reset_column_information
    WebPageType.connection.schema_cache.clear!
    WebPageType.reset_column_information

    news_type = WebPageType.create(:name=>"news")
    industry_type =  WebPageType.create(:name=>"industry")

    WebPage.all.each do |website|
      if website.url.include?("telegraph")
        website.active = false
      elsif website.url.include?("bbci.co.ukk") ||  website.url.include?("hsj.co.uk") ||
            website.url.include?("ehi.co.uk") ||   website.url.include?("rcn.org.uk")
        website.web_page_type=industry_type
      else
        website.web_page_type=news_type
      end
      website.save
    end

  end
end
