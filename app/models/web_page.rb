class WebPage < ActiveRecord::Base
  def store_classification_entity(name,response)
    self.send("#{name}_api_response=", response.to_json)
    self.save
    response.each do |item|
      puts item
      puts item["text"]
      puts item["relevance"]
      if item["relevance"].to_f>0.75
        self.send("#{name}_high_relevance") ? send("#{name}_high_relevance=",send("#{name}_high_relevance")+","+item['text']) : send("#{name}_high_relevance=",item['text'])
      elsif item["relevance"].to_f>0.5
        self.send("#{name}_med_relevance") ? send("#{name}_med_relevance=",send("#{name}_med_relevance")+","+item['text']) : send("#{name}_med_relevance=",item['text'])
      else
        self.send("#{name}_low_relevance") ? send("#{name}_low_relevance=",send("#{name}_low_relevance")+","+item['text']) : send("#{name}_low_relevance=",item['text'])
      end
    end
  end

  def classify!
    store_classification_entity("entities",AlchemyAPI::EntityExtraction.new.search(:url => self.url))
    store_classification_entity("keywords",AlchemyAPI::KeywordExtraction.new.search(:url => self.url))
    store_classification_entity("concepts",AlchemyAPI::ConceptTagging.new.search(:url => self.url))
    self.save
  end
end
