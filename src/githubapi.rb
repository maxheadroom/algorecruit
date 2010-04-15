require 'rubygems'
require 'net/http'
require 'net/https'
require 'yaml'
require 'json/pure'

class GithubAPI
  
  BASE_URL = "http://github.com/api/v2/"
  BASE_FORMAT = "json"
  
  
  
  # constructor
  def initialize(username, token)
    @github_user = username
    @token = token
  end
  
  
  def get_userinfo (user)
    # /user/show/:username
    verb = "get"
    # method = ('Net::HTTP::' + verb.to_s.capitalize).to_class
    url = BASE_URL + BASE_FORMAT + "/user/show/#{user}"
    uri = URI.parse url
    server = Net::HTTP.new(uri.host, uri.port)
    server.use_ssl = (uri.scheme == 'https')
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE if server.use_ssl?
    response = server.start do |http|
      req = Net::HTTP::Get.new(uri.path)
      # req.form_data = data.merge(auth)
      http.request(req)
    end
    
    JSON.parse(response.body)['user']
    
  end
  
  
  #end class
end