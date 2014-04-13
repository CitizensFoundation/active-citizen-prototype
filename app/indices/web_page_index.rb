ThinkingSphinx::Index.define :web_page, :with => :active_record do
  # fields
  indexes title
  indexes entities_high_relevance
  #indexes entities_med_relevance
  #indexes entities_low_relevance
  indexes keywords_high_relevance
  #indexes keywords_med_relevance
  #indexes keywords_low_relevance
  indexes concepts_high_relevance
  #indexes concepts_med_relevance
  #indexes concepts_low_relevance

  # attributes
  has created_at, updated_at, web_page_type_id, active
end