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
  
  # fetch userinformation about user
  def get_userinfo (user)
    # /user/show/:username
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
  
  
  # fetch the list of followings for user
  def get_followings (user)
    # /user/show/:user/following
    url = BASE_URL + BASE_FORMAT + "/user/show/#{user}/following"
    uri = URI.parse url
    server = Net::HTTP.new(uri.host, uri.port)
    server.use_ssl = (uri.scheme == 'https')
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE if server.use_ssl?
    response = server.start do |http|
      req = Net::HTTP::Get.new(uri.path)
      # req.form_data = data.merge(auth)
      http.request(req)
    end
    JSON.parse(response.body)
  end

  # fetch the list of followers to user
  def get_followers (user)
    # /user/show/:user/followers
    url = BASE_URL + BASE_FORMAT + "/user/show/#{user}/followers"
    uri = URI.parse url
    server = Net::HTTP.new(uri.host, uri.port)
    server.use_ssl = (uri.scheme == 'https')
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE if server.use_ssl?
    response = server.start do |http|
      req = Net::HTTP::Get.new(uri.path)
      # req.form_data = data.merge(auth)
      http.request(req)
    end
    JSON.parse(response.body)
  end

  
  #end class
end