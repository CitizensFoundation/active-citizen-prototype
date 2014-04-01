SKIP = ["Facebook","Terms of Service","NHS","Priorities Spaces","Privacy policy"]

class ExperimentsController < ApplicationController
  def nhs_citizen
    @pages = []
    WebPage.where(:active=>true).all.shuffle.each do |page|
      @pages << page if page.url.include?("nhs-citizen")
    end
  end

  def setup_field_weights
    @field_weights = {
        :title => 100,
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

    @all_entities = @page.all_entities

    @all_keywords =  (@page.keywords_high_relevance ? @page.keywords_high_relevance : "")+
        (@page.keywords_med_relevance ? ",#{@page.keywords_med_relevance}," : ",")+
        (@page.keywords_low_relevance ? @page.keywords_low_relevance : "")

    @all_concepts =  (@page.concepts_high_relevance ? @page.concepts_high_relevance : "")+
        (@page.concepts_med_relevance ? ",#{@page.concepts_med_relevance}," : ",")+
        (@page.concepts_low_relevance ? @page.concepts_low_relevance : "")


    #@all_search_items = @all_search_items.gsub("/"," ").split(",").reject{|w| w==""}
    @all_entities = @all_entities.gsub("/"," ").gsub("&"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.empty? || x.split(" ").count>3 || SKIP.include?(x)}.map{|w| " (#{w}) "}
    @all_keywords = @all_keywords.gsub("/"," ").gsub("&"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.empty? || x.split(" ").count>3 || SKIP.include?(x)}.map{|w| " (#{w}) "}
    @all_concepts = @all_concepts.gsub("/"," ").gsub("&"," ").gsub("-"," ").split(",").reject{|w| w==""}.reject{|x| x.empty? || x.split(" ").count>3 || SKIP.include?(x)}.map{|w| " (#{w}) "}

    @all_title_words = @page.title.split(" ").map{|x| x.gsub("!","").gsub("'","").gsub("-"," ").gsub("?","")}.reject{|x| x.empty? || x.split(" ").count>2 || SKIP.include?(x) || x.length<3}
    @all_title_words_grouped = []
    @all_title_words.each_slice(2).each do |words|
      @all_title_words_grouped << words.map{|w| "(#{w})"}.join(" ")
    end

    Rails.logger.debug @all_keywords
    @all_search_items = @all_entities[0..1]+@all_entities+
                        @all_keywords+
                        @all_concepts+
                        @all_title_words+@all_title_words+@all_title_words+@all_title_words+@all_title_words+@all_title_words+@all_title_words+@all_title_words
    Rails.logger.debug "--------------------------------------------------------------"
    Rails.logger.debug @all_search_items
  end

  def setup_query
    if false and @all_entities.length>1
      @query = "(#{@all_search_items[0]} & #{@all_search_items[1]}) & (#{@all_search_items[2..@all_search_items.length-1].join(" | ")})"
    else
      @query = "#{@all_search_items[0..@all_search_items.length-1].join(" | ")}"
    end
  end

  def search
    news_hits = ThinkingSphinx.search(@query, :ranker=>:wordcount,  :star=>true, :@field_weights=>@field_weights, :with => {:web_page_type_id => WebPageType.where(:name=>"news").first.id})[0..5]
    industry_hits = ThinkingSphinx.search(@query, :ranker=>:wordcount, :star=>true, :@field_weights=>@field_weights, :with => {:web_page_type_id => WebPageType.where(:name=>"industry").first.id})[0..1]
    #@excerpter = ThinkingSphinx::Excerpter.new 'web_page_core', @query
    @hits = (news_hits+industry_hits).shuffle
    Rails.logger.debug @hits.inspect
    #@hits += ThinkingSphinx.search(@page.concepts_high_relevance)[0..2]
    @hits = @hits.reject{|p| p.id==@page.id || p.url.include?("nhs-citizen")}.uniq
    @hits = @hits[0..8]
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
