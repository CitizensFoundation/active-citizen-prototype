class ExperimentsController < ApplicationController
  def match_pages
    field_weights = {
        :entities_high_relevance => 100,
        :entities_med_relevance    => 70,
        :entities_low_relevance => 40,
        :keywords_high_relevance => 60,
        :keywords_med_relevance    => 30,
        :keywords_low_relevance => 10,
        :concepts_high_relevance => 50,
        :concepts_med_relevance    => 20,
        :concepts_low_relevance => 5
    }
    @source_pages = []
    #.search {|page| page.url.include?("nhs-citizen")}
    WebPage.all.each do |page|
      next unless page.url.include?("nhs-citizen")
      all_entities =  [page.entities_high_relevance,page.entities_med_relevance,page.entities_low_relevance].join(",")
      query = all_entities.split(",").collect{|p| " *#{p}* "}.join(" ")
      if not all_entities.empty?
        hits = ThinkingSphinx.search(query, :field_weights=>field_weights)[0..2]
      else
        hits += ThinkingSphinx.search(page.keywords_high_relevance)[0..2]
      end
      #hits += ThinkingSphinx.search(page.concepts_high_relevance)[0..2]
      hits = hits.reject{|p| p.id==page.id}.uniq
      @source_pages << {:web_page=>page, :hits=>hits, :query=>query}
    end
  end
end
