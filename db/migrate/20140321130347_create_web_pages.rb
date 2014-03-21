class CreateWebPages < ActiveRecord::Migration
  def change
    create_table :web_pages do |t|
      t.string :url, :length=>2048, :null=>false
      t.text :entities_api_response
      t.text :entities_high_relevance
      t.text :entities_med_relevance
      t.text :entities_low_relevance
      t.text :keywords_api_response
      t.text :keywords_high_relevance
      t.text :keywords_med_relevance
      t.text :keywords_low_relevance
      t.text :concepts_api_response
      t.text :concepts_high_relevance
      t.text :concepts_med_relevance
      t.text :concepts_low_relevance
      t.timestamps
    end
  end
end
