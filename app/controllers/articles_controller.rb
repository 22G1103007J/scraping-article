class ArticlesController < ApplicationController
  def index
    scraper = Scraper.new('https://www.nikkansports.com/entertainment/news/')
    @articles = scraper.scrape_articles_by_author('桑沢拓徒')
  end
end
