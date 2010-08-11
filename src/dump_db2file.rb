require 'rubygems'
require 'net/http'
require 'yaml'
require 'cgi'
require 'bossman'
include BOSSMan
require 'mysql'
require 'githubapi'
require 'objectstash'

$stdout.sync = true
config = YAML.load_file("authconfig.yml")
github = GithubAPI.new(config["user_name"], config["token"])
dbhost = config["dbhost"]
dbuser = config["dbuser"]
dbpass = config["dbpass"]
dbname = config["dbname"]

# empty hash to hold the graph
graph = {}

####### mysql #########
begin
     # connect to the MySQL server
     dbh = Mysql.real_connect(dbhost, dbuser, dbpass, dbname)
     
     res = dbh.query("SELECT * FROM github_users")
     
     res.each_hash do |row|
        
          user = row['username']
          uid = row['id']
          # insert the user to the graph
          followers = github.get_followers_from_db(uid,dbh)
          graph[user] = []
          
          # printf("Add user %s\n", user)
          followers.each do |f|
            # printf("\tAdd Follower: %s\n", f)
            graph[user] << f
          end
          
      end

      
      res.free
     
     # get server version string and display it
     puts "Server version: " + dbh.get_server_info
   rescue Mysql::Error => e
     puts "Error code: #{e.errno}"
     puts "Error message: #{e.error}"
     puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
   ensure
     # disconnect from server
     dbh.close if dbh
end


# Stash it
ObjectStash.store graph, './theory_of_everything.stash'

