require 'selenium-webdriver'
require 'csv'


wait = Selenium::WebDriver::Wait.new(:timeout => 10)
enwords = CSV.read('english_words_test.csv')#array
File.open("google_trans_test.csv", "w") do |io|
  enwords.each{|word|
    driver = Selenium::WebDriver.for :chrome
    url  = "https://translate.google.co.jp/#en/ja/" + word[0]
    oneline = word[0]
    oneline+=","
    p "scraping "+url+" .."

    #example -> driver.get "https://translate.google.co.jp/#en/ja/run"#test
    driver.get url
    elements=driver.find_elements(:class_name => "gt-baf-cell")
    elements=driver.find_elements(:class_name => "gt-baf-word-clickable")

    if defined? elements
      elements.each do |element|
        if defined? element.text # && element.text.to_s.strip.length != 0
          #p io.print(element.text)
          #p element.text
          oneline+= element.text
          oneline+=","
        end
      end
    end
    p io.puts(oneline.chop.chomp)
    #sleep(10)
    driver.quit
  }
end
