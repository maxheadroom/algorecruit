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
    # server.use_ssl = (uri.scheme == 'https')
    # server.verify_mode = OpenSSL::SSL::VERIFY_NONE if server.use_ssl?
    response = server.start do |http|
      req = Net::HTTP::Get.new(uri.path)
      # req.form_data = data.merge(auth)
      http.request(req)
    end
    
    userinfo = []
    sleeptime = 30
    case response 
       when Net::HTTPSuccess
          userinfo = JSON.parse(response.body)['user']       
       when Net::HTTPForbidden
         puts "\n\tHave to wait for #{sleeptime} seconds\n"
          sleep sleeptime
          redo
       else
           puts "non-200: #{user} + #{response}"
    end
    
    
    
    
    if  userinfo == nil then
      return false
    else
      return userinfo
    end
    
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
    JSON.parse(response.body)['users']
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
    JSON.parse(response.body)['users']
  end

  # this method grasps the languages used in a repository
  # the information is exposed via the Web interface only
  def get_language_for_repo (repo, user)
    # XPath of the Language table
    # //div[@id='languages']/div[@class='popular compact']/table/tbody/tr[1]/td[1]/a

    # Get a Nokogiri::HTML:Document for the page we’re interested in...

    doc = Nokogiri::HTML(open("http://github.com/#{user}/#{repo}/graphs/languages"))

    # Do funky things with it using Nokogiri::XML::Node methods...

    #  puts doc
    #  puts doc.xpath('//div[@id=\'languages\']/div[@class=\'popular compact\']/table/tr')
    ####
    # Search for nodes by xpath 

    langs = Array.new

    doc.xpath('//div[@id=\'languages\']/div[@class=\'popular compact\']/table/tr').each do |tbody|
      # puts tbody.xpath('./td[1]/a').text()
      langs << tbody.xpath('./td[1]/a').text()
      # puts "----------------------\n"
      # puts tbody.xpath('//tr/td[1]/a/text()')
    end
    langs
  end
  
  
  # get the repositories of a user
  def get_public_repos (user)
    # //div[@id='main']/div[2][@class='site']/ul[@class='repositories']/li[1][@class='simple public fork']/h3/a
    doc = Nokogiri::HTML(open("http://github.com/#{user}/repositories"))
    

    repos = Array.new

    doc.xpath('//div[@id=\'main\']/div[2][@class=\'site\']/ul[@class=\'repositories\']/li').each do |tbody|
      # puts tbody.xpath('./h3/a').text()
      repos << tbody.xpath('./h3/a').text()

      # langs[i++] = tbody.xpath('./[@class=\'simple public fork\']/h3/a').text()
      # puts "----------------------\n"
      # puts tbody.xpath('//tr/td[1]/a/text()')
    end
    repos
    
  end
  
  # extend the graph with the users in
  def add_followers_to_graph( user, list, dgraph )
    
    list.each { |k|
      # add the following to the graph
      dgraph.add_vertex(k)
      # add the edge to the graph
      dgraph.add_edge(k, user)

      # printf("Following: %s \n", k)
      }
      dgraph
  end

  # extend the graph with the users in
  def add_followings_to_graph( user, list, dgraph )
    
    list.each { |k|
      # add the following to the graph
      dgraph.add_vertex(k)
      # add the edge to the graph
      dgraph.add_edge(user, k)

      # printf("Following: %s \n", k)
      }
      dgraph
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
 
 def add_bcscore_2db(user, bcscore, dbcon) 
    res = dbcon.query("UPDATE github_users SET bc_score = #{bcscore} WHERE username = '#{user}'")
 end

 def add_HITS_2db(user, authority, hub, dbcon) 
    res = dbcon.query("UPDATE github_users SET authority = #{authority}, hub = #{hub} WHERE username = '#{user}'")
 end
 
 
 
 def get_followers_from_db(uid,dbh)
   followers = []
   res = dbh.query("select t2.username as username from github_edges as t1 LEFT JOIN github_users as t2 ON t1.target=t2.id WHERE t1.source='#{uid}';")
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
    
   if !is_user_in_db(user.username, dbcon) then
     
          printf("\t\tUser: %s not in DB... inserting\n", user.username)
          dbcon.query("INSERT INTO github_users (username,label,location) VALUES('#{user.username}', '#{user.username}', '#{user.location}')")
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
  #end class
end


class GitHubUser
  
  
  
  attr_accessor :username, :repos, :followers, :followings, :location
  
  def initialize(user, githubapi)
    @username = user
    @repos = Hash.new
    userinfo = githubapi.get_userinfo(@username)
    @followers = githubapi.get_followers(@username)
    @followings = githubapi.get_followings(@username)
    @location = userinfo['location']
    
    githubapi.get_public_repos(@username).each { |rname|
      repo = GitHubRepo.new(@username, rname, githubapi)
      @repos[rname] = repo
    }
  end
  
  
end

class GitHubRepo
  attr_accessor :repo_name, :languages
  def initialize(user, repo, githubapi)
    @repo_name = repo
    @languages = githubapi.get_language_for_repo(repo, user)
  end
end
