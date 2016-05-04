require 'selenium-webdriver'
require 'csv'
require 'pp'
require 'set'

day = Time.now
time = "#{day.year}#{day.month}#{day.day}#{day.hour}#{day.min}"
error_log_filename="user_ids/user_profile_#{time}.log"
output_filename="user_ids/user_profile_#{time}.csv";
output_folder="user_ids/"

wait = Selenium::WebDriver::Wait.new(:timeout => 10)
driver = Selenium::WebDriver.for :chrome
File.open(error_log_filename, "w") do |errorlog|
  File.open(output_filename, "w") do |io|

    begin
      uid_set = Set.new []
      url = "https://japan.zulutrade.com/forex-traders#forex"
      p url
      driver.get url
        loop{
        5.times{
          driver.find_elements(:css, 'a.name').last.location_once_scrolled_into_view
          sleep(5.0)
        }
        sleep(5.0)

        puts driver.find_elements(:css, 'a.name').length
        driver.find_elements(:css,"a.name").each {|link|
          text = link.attribute("text")
          href = link.attribute("href")
          pp href

          if href =~ /([0-9]+)/
            pp $1
            if ! uid_set.include?($1)
              uid_set.add($1)
              io.puts "#{$1},\"#{href}\""
            end
          end
        }
      }

    rescue => error
      driver.quit
      driver = Selenium::WebDriver.for :chrome
      errorlog.puts error.message
      next
    end
  end
end
driver.quit
