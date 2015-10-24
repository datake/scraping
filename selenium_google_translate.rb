require 'selenium-webdriver'
require 'csv'

language="fr" #ja
input_filename="input/english_words.csv";
output_filename="output/en_fr_from_google_trans.csv";

i=0
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
enwords = CSV.read(input_filename)#array
File.open(output_filename, "w") do |io|
  enwords.each{|word|
    driver = Selenium::WebDriver.for :chrome
    url  = "https://translate.google.co.jp/#en/"+language+"/" + word[0]
    p "scraping "+url+" .."
    p i
    i+=1

    #example -> driver.get "https://translate.google.co.jp/#en/ja/run"#test
    driver.get url
    elements=driver.find_elements(:class_name => "gt-baf-cell")
    elements=driver.find_elements(:class_name => "gt-baf-word-clickable")

    if elements[0] && elements[0].text.to_s.strip.length > 0
      p elements[0].text.to_s.strip.length
    #unless elements[0].text.blank?
      oneline = word[0]
      oneline+=","
      elements.each do |element|
        #unless elements.text.blank?
        if element.text.to_s.strip.length > 0
          #p io.print(element.text)
          #p element.text
          oneline+= element.text
          oneline+=","
        end
      end
      #p io.puts(oneline.chop.chomp)
      io.puts(oneline.chop.chomp)
      #sleep(10)
    end

    driver.quit
  }
end
