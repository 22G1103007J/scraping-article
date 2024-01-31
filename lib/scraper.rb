require 'nokogiri'
require 'httparty'

class Scraper
  def initialize(url)
    @url = url
    @headers = { 'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3' }
  end

  def scrape_articles_by_author(author)
    response = HTTParty.get(@url, headers: @headers)
    html = Nokogiri::HTML(response.body)

    articles = []

    html.css('.newslist').each do |article_element|
      begin
        article_urls = article_element.xpath('.//a').map { |a| a['href'] }
        article_urls.each do |article_url|
          puts "Article URL: #{article_url}"
          article_page = HTTParty.get(article_url, headers: @headers)
          article_html = Nokogiri::HTML(article_page.body)

          title = find_title(article_html)
          published_at = find_date(article_html)
          article_author = find_author(article_html)

          next unless article_author == author

          articles << { title: title, published_at: published_at, author: article_author, article_url: article_url }
        end
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    end

    articles
  end

  private

  def find_title(article_html)
    article_html.css('h1').text.strip
  end

  def find_date(article_html)
    article_html.css('header time').text.strip
  end

  def find_author(article_html)
    meta_author = article_html.at_css('meta[name="author"]')
    meta_author&.attribute('content')&.value&.strip || ''
  end
end