module ApplicationHelper
  def create_carousel_urls_from_pages(pages)
    urls = ""
    pages.each_with_index do |page,i|
      urls += "{url:'#{page.screenshot.url(:full)}',width:1366,height:768},"
    end
    urls
  end
end
