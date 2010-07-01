require 'rubygems'
require 'net/http'
require 'yaml'
require 'cgi'
require 'bossman'
include BOSSMan
require 'mysql'
require 'githubapi'

$stdout.sync = true
puts "Getting URLs\n"
config = YAML.load_file("authconfig.yml")
BOSSMan.application_id = config["token"]
github = GithubAPI.new(config["user_name"], config["token"])
offset = 0
done = false
urls = []
users = []

printf("Fetching for %s \n", ARGV[0])


####### mysql #########
begin
     # connect to the MySQL server
     dbh = Mysql.real_connect("localhost", "ruby", "ruby", "algorecruit")
     
     res = dbh.query("SELECT * FROM github_users")
     
     res.each_hash do |row|
          printf("Checking: %s \n", row['username'])
          followers = row["followers"].split(',')
          followers.each {|f|
            printf("\t\t\t => %s <=\n", f)
            if !github.is_user_in_db(f, dbh) then
              github.add_user_to_db(f,dbh)
            end
            }
          followings = row["followings"].split(',')
          followings.each{|f|
            printf("\t\t\t => %s <=\n", f)
            if !github.is_user_in_db(f, dbh) then
              github.add_user_to_db(f,dbh)
            end
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