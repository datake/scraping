#!/usr/bin/ruby
require 'net/http'
require 'uri'
require 'json'
require 'logger'
require 'pp'
require 'complex'
require 'rubygems'
require 'google/api_client'
require 'trollop'
require 'pp'

SEARCH_QUERY = 'mr children'
DEVELOPER_KEY = 'AIzaSyBwE3CH2GCKAWnxT1xXoTjrk-p20EW5Tlw'
YOUTUBE_API_SERVICE_NAME = 'youtube'
YOUTUBE_API_VERSION = 'v3'
DATA_FILE='log/data.csv'
ERROR_LOG_FILE='log/error.log'

def get_service
  client = Google::APIClient.new(
    :key => DEVELOPER_KEY,
    :authorization => nil,
    :application_name => $PROGRAM_NAME,
    :application_version => '1.0.0'
  )
  youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

  return client, youtube
end

 def download(id)
   url = "http://www.youtube.com/watch?v=#{id}"
   result = `youtube-dl -f 18 #{url}`
   pp "downladed #{url}"
 end

def main
  opts = Trollop::options do
    opt :q, 'Search term', :type => String, :default => SEARCH_QUERY
    opt :max_results, 'Max results', :type => :int, :default => 50
  end

  client, youtube = get_service

  begin
    File.open(DATA_FILE, "w") do |datalog|
      File.open(ERROR_LOG_FILE, "w") do |errorlog|
        # Call the search.list method to retrieve results matching the specified
        # query term.
        search_response = client.execute!(
          :api_method => youtube.search.list,
          :parameters => {
            :part => 'snippet',
            :q => opts[:q],
            :maxResults => opts[:max_results]
          }
        )
        video = []
        videoId = []
        publishedAt = []
        channelId = []
        title = []
        description = []
        channelId = []
        title = []
        thumbnails = []
        channelTitle = []

        search_response.data.items.each do |search_result|
          case search_result.id.kind
            when 'youtube#video'
              pp "downlading .."
              download(search_result.id.videoId)
              video << "#{search_result.id.videoId},#{search_result.snippet.title},
                          #{search_result.snippet.publishedAt},#{search_result.snippet.channelId},
                          #{search_result.snippet.description},#{search_result.snippet.thumbnails.default.url},
                          #{search_result.snippet.channelTitle},#{search_result.snippet.liveBroadcastContent}"

          end
          datalog.puts video
        end
      end
    end
  rescue Google::APIClient::TransmissionError => e
    errorlog.puts error.message
  end
end
main
