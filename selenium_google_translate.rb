require 'selenium-webdriver'
require 'csv'

=begin
英語から日本語への単語
https://www.googleapis.com/language/translate/v2?key=【ここに自分のkeyを記述】&target=【翻訳前言語】&q=【検索文字列】&source=【翻訳後言語】
id:インドネシア
ms:マレー
jw:ジャワ
su:スンダ

en:英語
ja:日本語
de:ドイツ語
fr:フランス

=end


#ここを変更する
language_from="en"
language_to="fr"
start_from_this_line = 0
input_filename="input/english_words.csv"; #"input/inds.csv"
output_filename="output/"+language_from+"_"+language_to+"_from_selenium.csv";
error_log_filename="output/"+language_from+"_"+language_to+"_from_selenium.log"
#ここまで

i=0
wait = Selenium::WebDriver::Wait.new(:timeout => 10)
enwords = CSV.read(input_filename)#array
driver = Selenium::WebDriver.for :chrome

File.open(error_log_filename, "w") do |errorlog|
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
          errorlog.puts "getting "+url+" .."
          errorlog.puts i
          errorlog.puts error.message
          next
        end
      end

    }

  end
end
driver.quit
