require 'selenium-webdriver'
require 'csv'

language_from="en"
language_to="fr"
start_from_this_line = 0
input_filename="input/english_words.csv";
output_filename="output/"+language_from+"_"+language_to+"_from_selenium.csv";


i=0
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
enwords = CSV.read(input_filename)#array
driver = Selenium::WebDriver.for :chrome

File.open(output_filename, "w") do |io|
  enwords.each{|word|
    if i< start_from_this_line
      i+=1
      next
    else
      begin
        #driver = Selenium::WebDriver.for :chrome
        url  = "https://translate.google.co.jp/#"+language_from+"/"+language_to+"/" + word[0]
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
        #driver.quit
      rescue => error
        driver.quit
        driver = Selenium::WebDriver.for :chrome
        puts error.message
        next
      end
    end

  }

end
driver.quit
