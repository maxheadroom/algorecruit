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
BOSSMan.application_id = config["token"]
github = GithubAPI.new(config["user_name"], config["token"])
# empty hash to hold the graph
graph = {}

####### mysql #########
begin
  # connect to the MySQL server
  dbh = Mysql.real_connect("localhost", "ruby", "ruby", "algorecruit")

  res = dbh.query("SELECT * FROM github_users")

  res.each_hash do |row|

    user = row['username']
    # insert the user to the graph
    printf("<node id=\"%i\" label=\"%s\"/>\n", row["id"], user)
    
    
    followers = row["followers"].split(',')
    i = 0.to_int
    followers.each {|f|
      
      fid = github.get_id_from_user(f, dbh)
      
      printf("<edge id=\"%s\" source=\"%s\" target=\"%s\" />\n", i, row["id"] , fid)
      
      dbh.query("INSERT INTO github_edges (source, target) VALUES('#{row["id"]}', '#{fid}')")
      
      i += 1
    }
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