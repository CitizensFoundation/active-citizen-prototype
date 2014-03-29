SKIP = ["Facebook","Terms of Service"]

class ExperimentsController < ApplicationController
  def nhs_citizen
    @pages = []
    WebPage.where(:active=>true).all.each do |page|
      @pages << page if page.url.include?("nhs-citizen")
    end
  end

  def setup_field_weights
    @field_weights = {
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
  end

  def setup_match(web_page_id)
    @page = WebPage.find(web_page_id)

    @all_entities =  (@page.entities_high_relevance ? @page.entities_high_relevance : "")+
        (@page.entities_med_relevance ? ",#{@page.entities_med_relevance}," : ",")+
        (@page.entities_low_relevance ? @page.entities_low_relevance : "")

    @all_keywords =  (@page.keywords_high_relevance ? @page.keywords_high_relevance : "")+
        (@page.keywords_med_relevance ? ",#{@page.keywords_med_relevance}," : ",")+
        (@page.keywords_low_relevance ? @page.keywords_low_relevance : "")

    @all_concepts =  (@page.concepts_high_relevance ? @page.concepts_high_relevance : "")+
        (@page.concepts_med_relevance ? ",#{@page.concepts_med_relevance}," : ",")+
        (@page.concepts_low_relevance ? @page.concepts_low_relevance : "")


    #@all_search_items = @all_search_items.gsub("/"," ").split(",").reject{|w| w==""}
    @all_entities = @all_entities.gsub("/"," ").gsub("&"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222 || SKIP.include?(x)}.map{|w| " (#{w}) "}
    @all_keywords = @all_keywords.gsub("/"," ").gsub("&"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222 || SKIP.include?(x)}.map{|w| " (#{w}) "}
    @all_concepts = @all_concepts.gsub("/"," ").gsub("&"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.split(" ").count>1222 || SKIP.include?(x)}.map{|w| " (#{w}) "}
    Rails.logger.debug @all_keywords
    @all_search_items = @all_entities[0..500]+@all_keywords[0..7]+=@all_concepts[0..7]
    Rails.logger.debug @all_search_items
  end

  def setup_query
    if @all_entities.length>1
      @query = "(#{@all_search_items[0]} & #{@all_search_items[1]}) & (#{@all_search_items[2..@all_search_items.length-1].join(" | ")})"
    else
      @query = "(#{@all_search_items[0..@all_search_items.length-1].join(" | ")})"
    end
  end

  def search
    @hits = ThinkingSphinx.search(@query, :ranker=>:wordcount, :star=>true, :@field_weights=>@field_weights)[0..7000]
    Rails.logger.debug @hits.inspect
    #@hits += ThinkingSphinx.search(@page.concepts_high_relevance)[0..2]
    @hits = @hits.reject{|p| p.id==@page.id || p.url.include?("nhs-citizen")}.uniq
    @hits = @hits[0..7]
    #@hits.context.panes << ThinkingSphinx::Panes::ExcerptsPane
  end

  def match
    setup_field_weights
    setup_match(params[:id])
    if @all_search_items.length>2
      setup_query
      search
      @pages = [@page]+@hits # unless @page.url.include?("nhs-citizen")
    end
  end

  def match_pages
    setup_field_weights
    @source_pages = []
    #.search {|@page| @page.url.include?("nhs-citizen")}
    WebPage.all.each do |page|
      next unless page.url.include?("nhs-citizen")
      setup_match(page.id)
      if @all_search_items.length>2
        setup_query
        search
        @source_pages << {:web_page=>page, :hits=>@hits, :query=>@query}# unless page.url.include?("nhs-citizen")
      end
    end
  end
end
