# Author::    Falko Zurell  (mailto:falko.zurell@gmail.com)
# Copyright:: Copyright (c) 2010 Falko Zurell
# License::   GNU FDL

require 'rubygems'
require 'net/http'
require 'net/https'
require 'yaml'
require 'json/pure'
require 'nokogiri'
require 'open-uri'
require 'rgl/adjacency'

# this class implements the Github API
class GithubAPI

  config = YAML.load_file("authconfig.yml")
  
  BASE_URL = "http://github.com/api/v2/"
  BASE_FORMAT = "json"
  PROXY_HOST=config["proxy_host"]
  PROXY_PORT=config["proxy_port"]
  
  
  
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
    server = Net::HTTP::Proxy(PROXY_HOST, PROXY_PORT).new(uri.host, uri.port)
    # server.use_ssl = (uri.scheme == 'https')
    # server.verify_mode = OpenSSL::SSL::VERIFY_NONE if server.use_ssl?
    userinfo = nil
    
    retries = 60
    while retries > 0 do 
        response = server.start do |http|
          req = Net::HTTP::Get.new(uri.path)
          # req.form_data = data.merge(auth)
          http.request(req)
        end
        
        case response 
           when Net::HTTPSuccess
              userinfo = JSON.parse(response.body)['user'] 
              break      
           when Net::HTTPForbidden
             puts "\n\tHave to wait for a second: #{retries}"
              sleep 1
              retries = retries - 1
              next
           when Net::HTTPNotFound
             puts "ERROR: User #{user} not found on github.com\n"
             break
           else
               puts "non-200: #{user} + #{response}"
        end #case
    end #while
    
    if retries == 0 then
      puts "ERROR: Couldn't fetch userinfo for #{user} due to Network errors\n"
    end
    
      return userinfo
    
  end
  
  
  # fetch the list of followings for user
  def get_followings (user)
    # /user/show/:user/following
    url = BASE_URL + BASE_FORMAT + "/user/show/#{user}/following"
    uri = URI.parse url
    # server = Net::HTTP.new(uri.host, uri.port)
    server = Net::HTTP::Proxy(PROXY_HOST, PROXY_PORT).new(uri.host, uri.port)
    server.use_ssl = (uri.scheme == 'https')
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE if server.use_ssl?
    response = server.start do |http|
      req = Net::HTTP::Get.new(uri.path)
      # req.form_data = data.merge(auth)
      http.request(req)
    end
    JSON.parse(response.body)['users']
  end

  # fetch the list of followers to user
  def get_followers (user)
    # /user/show/:user/followers
    url = BASE_URL + BASE_FORMAT + "/user/show/#{user}/followers"
    uri = URI.parse url
    #server = Net::HTTP.new(uri.host, uri.port)
    server = Net::HTTP::Proxy(PROXY_HOST, PROXY_PORT).new(uri.host, uri.port)
    server.use_ssl = (uri.scheme == 'https')
    server.verify_mode = OpenSSL::SSL::VERIFY_NONE if server.use_ssl?
    response = server.start do |http|
      req = Net::HTTP::Get.new(uri.path)
      # req.form_data = data.merge(auth)
      http.request(req)
    end
    JSON.parse(response.body)['users']
  end

  
  
  def is_user_in_db(user, dbcon)
   ret = nil
   res = dbcon.query("SELECT id,username FROM github_users WHERE username = '#{user}'")
   
   if (res.num_rows() == 0) then
      # user not found in DB
      # should be inserted
     ret = false
   elsif ( res.num_rows() == 1) then
     # user found return ID
     res.each_hash do |row|
        ret = true
      end
   else 
     # more than one user found, invalid result
     ret = nil
   end
   
   res.free
   ret
   
 end
 
 
 def get_followers_from_db(uid,dbh)
   followers = []
   res = dbh.query("select t2.username as username from github_edges as t1 LEFT JOIN github_users as t2 ON t1.source=t2.id WHERE t1.target='#{uid}';")
   res.each_hash{|r|
     followers << r["username"]
     
   }
   res.free
   return followers
   
 end
 
 
 def add_edge(source, target, dbcon)
   dbcon.query("INSERT INTO github_edges (source, target) VALUE('#{source}','#{target}')")
 end
 
 # add a user to the DB github_users and return the created ID for
 # the user
 def add_follower(user, dbcon)
   ret = nil
   dbcon.query("INSERT INTO github_users (username,label) VALUES('#{user}','#{user}')")
   
   res = dbcon.query("SELECT id,username FROM github_users WHERE username = '#{user}'")
   
   res.each_hash do |row|
       ret = row["id"]
   end
   res.free
   ret
   
 end
 
 # accepts an Object of type GitHubUser
 def add_user_to_db(user,dbcon)
   
   ret = false
   tries = 60

   
   sth = dbcon.prepare("INSERT INTO github_users (username,label,location) VALUES(?, ?, ?)")
    
   if !is_user_in_db(user.username, dbcon) then
     
          printf("\t\tUser: %s not in DB... inserting\n", user.username)
          sth.execute(user.username, user.username, user.location)

          res = dbcon.query("SELECT id,username FROM github_users WHERE username = '#{user.username}'")

           res.each_hash do |row|
               ret = row["id"]
           end
           res.free
   else
          printf("\t\tUser: %s already in DB. Not inserting\n", user.username)
          ret = false
   end
   
   ret 
   
 end

   def get_id_from_user(user,dbcon)
     res = dbcon.query("SELECT * FROM github_users WHERE username=\"#{user}\"")
     if res != nil then
       res.each_hash do |row|
         id = row["id"]
         printf("\t\t FollowerID of %s = %i\n", user ,id.to_s)
         res.free
         return id
       end
     else
       res.free
       return false
     end
   end
   
   
   
   def add_scores2db(user,bc,authority,hub,dbcon)
     
     
     sth = dbcon.prepare("UPDATE github_users SET BC = ?,AUTH=?,HUB=? WHERE username = ?")
     result = sth.execute(bc, authority, hub, user)
     
     puts "Result: #{result}" 
      
     
    end
   
   
  #end class
end


class GitHubUser
  
  
  
  attr_accessor :username, :repos, :followers, :followings, :location
  
  def initialize(user, githubapi)
    userinfo = githubapi.get_userinfo(user)

	# puts "Userinfo: #{userinfo} \n"
	if userinfo != nil then
		@username = userinfo['login']
    		@followers = githubapi.get_followers(@username)
    		@followings = githubapi.get_followings(@username)
    		@location = userinfo['location']
	end
    
  end
  
  
end

