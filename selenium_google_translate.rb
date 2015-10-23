require 'selenium-webdriver'
require 'csv'

input_filename="english_words.csv";
output_filename="out_from_google_trans.csv";
i=0
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
enwords = CSV.read(input_filename)#array
File.open(output_filename, "w") do |io|
  enwords.each{|word|
    driver = Selenium::WebDriver.for :chrome
    url  = "https://translate.google.co.jp/#en/ja/" + word[0]
    p "scraping "+url+" .."
    p i
    i+=1

    #example -> driver.get "https://translate.google.co.jp/#en/ja/run"#test
    driver.get url
    elements=driver.find_elements(:class_name => "gt-baf-cell")
    elements=driver.find_elements(:class_name => "gt-baf-word-clickable")

    if defined? elements
      oneline = word[0]
      oneline+=","
      elements.each do |element|
        if defined? element.text && element.text.to_s.strip.length != 0
          #p io.print(element.text)
          #p element.text
          oneline+= element.text
          oneline+=","
        end
      end
    end
    #p io.puts(oneline.chop.chomp)
    io.puts(oneline.chop.chomp)
    #sleep(10)
    driver.quit
  }
end
