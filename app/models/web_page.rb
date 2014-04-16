class WebPage < ActiveRecord::Base

  #scope :active => where(:active=>true)

  has_attached_file :screenshot,
                    :styles => { :full => "", :large => "", :medium=>"", :small=>"", :thumb=>"" },
                    :convert_options => {
                        :full => "-gravity north -thumbnail 1366x768^ -extent 1366x768",
                        :large => "-gravity north -thumbnail 683x384^ -extent 683x384",
                        :medium => "-gravity north -thumbnail 341x192^ -extent 341x192",
                        :small => "-gravity north -thumbnail 170x96^ -extent 170x96",
                        :thumb => "-gravity north -thumbnail 85x48^ -extent 85x48"
                    },
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :screenshot, :content_type => /\Aimage\/.*\Z/

  belongs_to :web_page_type

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

  def set_main_text!
    self.update_attribute(:main_text, AlchemyAPI::TextExtraction.new.search(:url => self.url))
  end

  def all_entities
    (self.entities_high_relevance ? self.entities_high_relevance : "")+
        (self.entities_med_relevance ? ",#{self.entities_med_relevance}," : ",")+
        (self.entities_low_relevance ? self.entities_low_relevance : "")
  end

  def self.dedup!
    grouped = where(:active=>true).order("created_at DESC").group_by{|page| [page.title] }
    grouped.values.each do |duplicates|
      first_one = duplicates.pop
      unless duplicates.empty?
        duplicates.sort_by{|d| d.created_at}.each do |double|
          Rails.logger.info("Deactivated duplicates of #{first_one.url} from here #{double.url}")
          double.active=false
          double.save
        end
      end
    end
  end
end
