require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'


class SimpleScraper
  attr_accessor :agent

  def initialize
    self.agent = Mechanize.new
  end



  # The main scraping code
  #
  def scrape

    # Page with list of games
    list_page = agent.get("http://www.casiopeia.net/forum/downloads.php?cat=31")
    log_page(list_page)

    # Iterate game page links
    list_page.links_with(css: ".forumtitle").each do |game_page_link|
      log_link(game_page_link)

      # Follow game link
      game_page = game_page_link.click
      log_page(game_page)

      # Click the form submit button
      download_form = game_page.form_with(id: "download")
      log_form(download_form)

      file_result = download_form.click_button
      log_file(file_result)

      # Save to file
      file_result.save

    end # link iterator
  end # scraper



  # Helper function for logging ########################3
  #
  def log_link link
    puts "Link, #{link.text}, #{link.uri.to_s}"
  end

  def log_page page
    puts "Page, #{page.title}, #{page.uri.to_s}"
  end

  def log_form form
    puts "Form, #{form.action}, #{form.keys}"
  end

  def log_file file
    puts "File, #{file.filename}, #{file.content.size/1024.0}KB, #{file.uri.to_s}"
  end
end


# Run the program
SimpleScraper.new.scrape
