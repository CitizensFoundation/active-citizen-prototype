namespace :experiment do
  desc "Screenshots"
  task :screenshots => :environment do
    headless = Headless.new
    headless.start
    page = WebPage.first
    browser = Watir::Browser.start page.url
    browser.window.resize_to(1366, 768)
    page.title = browser.title
    puts browser.title
    page.screenshot = browser.screenshot.png
    page.save
    browser.close
    headless.destroy
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