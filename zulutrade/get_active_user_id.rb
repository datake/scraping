require 'selenium-webdriver'
require 'csv'
require 'pp'
require 'set'

day = Time.now
time = "#{day.year}#{day.month}#{day.day}#{day.hour}#{day.min}"
error_log_filename="user_ids/user_profile_#{time}.log"
output_filename="user_ids/user_profile_#{time}.csv";
output_folder="user_ids/"

wait = Selenium::WebDriver::Wait.new(:timeout => 30)
driver = Selenium::WebDriver.for :chrome
File.open(error_log_filename, "w") do |errorlog|
  File.open(output_filename, "w") do |io|

    # begin
    uid_set = Set.new []
    scroll_done = 0
    scroll_num = 100
    url = "https://japan.zulutrade.com/forex-traders#forex"
    p url
    driver.get url
    loop{
      begin
        scroll_num.times{
          driver.find_elements(:css, 'a.name').last.location_once_scrolled_into_view
          scroll_done += 1
          sleep(5.0)
        }
        pp "#{scroll_done} times scrolled"
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
          # }
        }

      rescue => error
        errorlog.puts error.message
        driver.quit
        driver = Selenium::WebDriver.for :chrome
        url = "https://japan.zulutrade.com/forex-traders#forex"
        driver.get url
        (scroll_done + 1).times{
          driver.find_elements(:css, 'a.name').last.location_once_scrolled_into_view
          sleep(5.0)
        }
        errorlog.puts error.message
        next
      end
    }
  end
end
driver.quit
