require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.get "http://www.example.com/"

# 一般のセレクタ
elements = driver.find_elements(:id => "myid") # ID <div id="myid"></div>
elements = driver.find_elements(:class_name => "myclass") # クラス <div class="myclass"></div>
elements = driver.find_elements(:tag_name => "div") # タグの種類 <div class="myclass1"></div>, <div class="myclass2"></div>,...
elements = driver.find_elements(:name => "myname") # 名前 <div name="myname"></div>
elements = driver.find_elements(:xpath => "address") # XPath
elements = driver.find_elements(:css => "ul#smaple-id li") # CSSセレクタ

# <a>タグに特化したセレクタ
elements = driver.find_elements(:link_text => "click") # <a href="">click</a>
elements = driver.find_elements(:partial_link_text => "click") # <a href="">click here</a>

# メソッドチェーン
elements = driver.find_element(:tag_name => "body").find_elements(:xpath => 'div/p/a')

# イテレート
elements.each do |element|
  puts element.text.encode('UTF-8')
end
