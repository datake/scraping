require 'net/http'
require 'uri'
require 'json'
require 'csv'

=begin
英語から日本語への単語
https://www.googleapis.com/language/translate/v2?key=【ここに自分のkeyを記述】&target=【翻訳前言語】&q=【検索文字列】&source=【翻訳後言語】
id:インドネシア
ms:マレー
jw:ジャワ
su:スンダ

=end

input_filename="input/inds.csv"
output_filename="output/id_jw_from_api.csv"
i=0
mytoken="AIzaSyBwE3CH2GCKAWnxT1xXoTjrk-p20EW5Tlw"
language_from="id"
language_to="jw"
start_from_this_line = 4444

enwords = CSV.read(input_filename)#array


def get_json(location, limit = 10)
  raise ArgumentError, 'too many HTTP redirects' if limit == 0
  uri = URI.parse(location)
  begin
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.get(uri.request_uri)
    end
    case response
    when Net::HTTPSuccess
      json = response.body
      JSON.parse(json)
    when Net::HTTPRedirection
      location = response['location']
      warn "redirected to #{location}"
      get_json(location, limit - 1)
    else
      puts [uri.to_s, response.value].join(" : ")
      # handle error
    end
  rescue => e
    puts [uri.to_s, e.class, e].join(" : ")
    # handle error
  end
end

File.open(output_filename, "w") do |io|
  enwords.each{|word|

    if i< start_from_this_line
      i+=1
      next
    else
      begin
        url = "https://www.googleapis.com/language/translate/v2?key=" + mytoken + "&target=" +
                language_to + "&source=" + language_from + "&q=" + word[0];
                p "getting "+url+" .."
                p i
                i+=1

        #puts get_json(url)#{"data"=>{"translations"=>[{"translatedText"=>"abad"}]}}
        if get_json(url)["data"]["translations"][0]["translatedText"]
            io.puts(word[0]+","+get_json(url)["data"]["translations"][0]["translatedText"])
        end
        #sleep(0.2)
      rescue => error
        puts error.message
        next
      end
    end

  }
end
