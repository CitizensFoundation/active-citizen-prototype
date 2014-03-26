namespace :experiment do
  desc "Screenshots"
  task :screenshots => :environment do
    headless = Headless.new
    headless.start
    browser = Watir::Browser.start "https://www.yrpri.org"
    browser.window.resize_to(1366, 768)
    WebPage.order("random()").all.each do |page|
      next if page.screenshot? and page.screenshot.exists?
      browser.goto page.url
      page.title = browser.title
      puts browser.title
      data = StringIO.new(browser.screenshot.png)
      data.class.class_eval { attr_accessor :original_filename, :content_type }
      data.original_filename = "screenshot.png"
      data.content_type = "image/png"
      page.screenshot = data
      page.save
    end
    browser.close
    headless.destroy
  end



  desc "Search and add telegraph links"
  task :search_and_add_telegraph_links => :environment do
    urls = []
    next_url = "http://www.telegraph.co.uk/search/?queryText=#{URI.escape(ENV['term'])}&type=relevant&sort=date%3AD%3AL%3Ad1&startIndex=0&site=default_collection&version="
    counter = 0
    while next_url do
      puts "Checking #{next_url}"
      doc = Nokogiri::HTML.parse(open(next_url))
      #puts doc.xpath('//a').map { |link| link['href'] }
      doc.xpath('//a').map { |link| link['href'] }.select{|x| x ? x.include?("www.telegraph.co.uk/health") : false}.each do |url_from_telegraph|
        urls << url_from_telegraph
        unless WebPage.where(:url=>url_from_telegraph).first
          puts "Create #{url_from_telegraph}"
          WebPage.create(:url=>url_from_telegraph)
        end
      end
      next_url = nil
      unless (counter+=1)>90
        #puts doc.xpath('//a').map { |link| link['class'] }
        doc.xpath('//a').map { |link| [link['href'],link['class']] }.select{|x| (x[1]=="searchNext" || x[1]=="moreresults") if x[1]}.each do |url_from_telegraph|
          next_url = "http://www.telegraph.co.uk#{URI.escape(url_from_telegraph[0])}"
          puts next_url
        end
      end
    end
    puts urls.uniq
    puts urls.uniq.count
  end

  desc "Search and add bbc links"
  task :search_and_add_bbc_links => :environment do
    urls = []
    next_url = "http://www.bbc.co.uk/search/news/?q=#{URI.escape(ENV['term'])}"
    counter = 0
    while next_url do
      puts "Checking #{next_url}"
      doc = Nokogiri::HTML.parse(open(next_url))
      doc.xpath('//a').map { |link| link['href'] }.select{|x| x.include?("www.bbc.co.uk/news") }.each do |url_from_bbc|
        urls << url_from_bbc
        unless WebPage.where(:url=>url_from_bbc).first
          puts "Create #{url_from_bbc}"
          WebPage.create(:url=>url_from_bbc)
        end
      end
      next_url = nil
      unless (counter+=1)>40
        doc.xpath('//a').map { |link| link['href'] }.select{|x| x.include?("search/news/?page=") }.each do |url_from_bbc|
          next_url = "http://www.bbc.co.uk#{URI.escape(url_from_bbc)}"
        end
      end
    end
    puts urls
  end

  desc "Classify all"
  task :classify_all => :environment do
    WebPage.where("keywords_api_response IS NULL OR entities_api_response IS NULL OR concepts_api_response IS NULL").order("random()").each do |page|
      page.classify!
    end
  end

  desc "Scan"
  task :scan => :environment do
    #WebPage.delete_all
    nhs_citizen = [
      "https://nhs-citizen.yrpri.org/ideas/489-add-points-for-and-against-ideas",
      "https://nhs-citizen.yrpri.org/ideas/528-free-wifi-at-all-nhs-facilities",
      "https://nhs-citizen.yrpri.org/ideas/581-publish-an-online-citizens-guide-to-current-nhs-finances",
      "https://nhs-citizen.yrpri.org/ideas/536-how-to-reduce-postcode-lottery-under-ccg-commissioning",
      "https://nhs-citizen.yrpri.org/ideas/611-better-joinedup-care-between-hospitals",
      "https://nhs-citizen.yrpri.org/ideas/539-talking-to-another-patient-should-part-of-the-consent-form",
      "https://nhs-citizen.yrpri.org/ideas/612-improved-support-for-people-with-dementia-and-their-carers",
      "https://nhs-citizen.yrpri.org/ideas/593-bringing-agitators-to-the-fore" ]
    bbc_health = [
      "http://www.bbc.com/news/uk-wales-politics-26684348",
      "http://www.bbc.com/news/uk-england-berkshire-26678434",
      "http://www.bbc.com/news/uk-wales-26676534",
      "http://www.bbc.com/news/health-26660713",
      "http://www.bbc.com/news/health-26647668",
      "http://www.bbc.com/news/health-26654617",
      "http://www.bbc.com/news/uk-scotland-edinburgh-east-fife-26651174",
      "http://www.bbc.com/news/uk-wales-26648061" ]
    bbc_technology = [
      "http://www.bbc.com/news/technology-26677291",
      "http://www.bbc.com/news/technology-13846031",
      "http://www.bbc.com/news/technology-26659929",
      "http://www.bbc.com/news/technology-26675445",
      "http://www.bbc.com/news/business-26641301",
      "http://www.bbc.com/news/technology-26651179",
      "http://www.bbc.com/news/technology-26682298",
      "http://www.bbc.com/news/uk-england-birmingham-26581484",
      "http://www.bbc.com/news/technology-26479134"]
    [nhs_citizen,bbc_health,bbc_technology].each do |i|
      i.each do |url|
        puts url
        page = WebPage.new
        page.url = url
        page.classify!
      end
    end
  end

end
