class ExperimentsController < ApplicationController
  def nhs_citizen
    @pages = []
    WebPage.all.each do |page|
      @pages << page if page.url.include?("nhs-citizen")
    end
  end

  def match
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

    page = WebPage.find(params[:id])

    all_entities =  (page.entities_high_relevance ? page.entities_high_relevance : "")+
        (page.entities_med_relevance ? ",#{page.entities_med_relevance}," : ",")+
        (page.entities_low_relevance ? page.entities_low_relevance : "")

    all_keywords =  (page.keywords_high_relevance ? page.keywords_high_relevance : "")+
        (page.keywords_med_relevance ? ",#{page.keywords_med_relevance}," : ",")+
        (page.keywords_low_relevance ? page.keywords_low_relevance : "")

    all_concepts =  (page.concepts_high_relevance ? page.concepts_high_relevance : "")+
        (page.concepts_med_relevance ? ",#{page.concepts_med_relevance}," : ",")+
        (page.concepts_low_relevance ? page.concepts_low_relevance : "")

    Rails.logger.debug all_entities
    #all_entities = all_entities.gsub("/"," ").split(",").reject{|w| w==""}
    all_entities = all_entities.gsub("/"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222}.map{|w| " (#{w}) "}
    all_keywords = all_keywords.gsub("/"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222}.map{|w| " (#{w}) "}
    all_concepts = all_concepts.gsub("/"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222}.map{|w| " (#{w}) "}
    Rails.logger.debug all_keywords
    all_entities = all_entities[0..10]+all_keywords[0..5]
    all_entities += all_concepts[0..5]
    Rails.logger.debug all_entities
    if all_entities.length>2
      query = "#{all_entities[0]} & #{all_entities[1]} | (#{all_entities[2..all_entities.length-1].join(" | ")})"

      hits = ThinkingSphinx.search(query, :ranker=>:bm25, :field_weights=>field_weights)[0..8]
      Rails.logger.debug hits.inspect
      #hits += ThinkingSphinx.search(page.concepts_high_relevance)[0..2]
      hits = hits.reject{|p| p.id==page.id}.uniq
      #hits.context.panes << ThinkingSphinx::Panes::ExcerptsPane
      @pages = [page]+hits # unless page.url.include?("nhs-citizen")
    end
  end


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
      Rails.logger.debug page.title
      Rails.logger.debug page.entities_high_relevance
      Rails.logger.debug page.entities_med_relevance
      Rails.logger.debug page.entities_low_relevance

      all_entities =  (page.entities_high_relevance ? page.entities_high_relevance : "")+
                      (page.entities_med_relevance ? ",#{page.entities_med_relevance}," : ",")+
                      (page.entities_low_relevance ? page.entities_low_relevance : "")

      all_keywords =  (page.keywords_high_relevance ? page.keywords_high_relevance : "")+
                      (page.keywords_med_relevance ? ",#{page.keywords_med_relevance}," : ",")+
                      (page.keywords_low_relevance ? page.keywords_low_relevance : "")

      all_concepts =  (page.concepts_high_relevance ? page.concepts_high_relevance : "")+
                      (page.concepts_med_relevance ? ",#{page.concepts_med_relevance}," : ",")+
                      (page.concepts_low_relevance ? page.concepts_low_relevance : "")

      Rails.logger.debug all_entities
      #all_entities = all_entities.gsub("/"," ").split(",").reject{|w| w==""}
      all_entities = all_entities.gsub("/"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222}.map{|w| " (#{w}) "}
      all_keywords = all_keywords.gsub("/"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222}.map{|w| " (#{w}) "}
      all_concepts = all_concepts.gsub("/"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222}.map{|w| " (#{w}) "}
      Rails.logger.debug all_keywords
      all_entities = all_entities[0..3]+all_keywords[0..1]
      all_entities += all_concepts[0..1]
      Rails.logger.debug all_entities
      if all_entities.length>2
        query = "#{all_entities[0]} & #{all_entities[1]} | (#{all_entities[2..all_entities.length-1].join(" | ")})"

        hits = ThinkingSphinx.search(query, :ranker=>:wordcount, :field_weights=>field_weights)[0..4]
        Rails.logger.debug hits.inspect
        #hits += ThinkingSphinx.search(page.concepts_high_relevance)[0..2]
        hits = hits.reject{|p| p.id==page.id}.uniq
        #hits.context.panes << ThinkingSphinx::Panes::ExcerptsPane
        @source_pages << {:web_page=>page, :hits=>hits, :query=>query}# unless page.url.include?("nhs-citizen")
      end
    end
  end
end
