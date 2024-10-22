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
dbhost = config["dbhost"]
dbuser = config["dbuser"]
dbpass = config["dbpass"]
dbname = config["dbname"]
BOSSMan.application_id = config["token"]
github = GithubAPI.new(config["user_name"], config["token"])
offset = 0
done = false
urls = []
users = []

printf("Fetching for %s \n", ARGV[0])

while !done
    results = BOSSMan::Search.web('site:github.com location "' + ARGV[0] + '" "profile - github"', :start => offset)
    
    if results.count.to_i > 0 then
    offset += results.count.to_i
    if offset > results.totalhits.to_i
        done = true
    end
#    urls += results.results.map { |r| r.url }
    users += results.results.map{|r|
        
        line = r.url
        line.match(/http:\/\/github.com\/([a-zA-Z0-9-]+)/)
        me = $1
        
        printf("Username: %s\n", me)
        if (me != nil)
            me = $1
        end      
      }
    else
      done = true
    end
end

printf("Number of results: %s \n",  users.size)

# process the list of users

####### mysql #########
begin
     # connect to the MySQL server
     dbh = Mysql.real_connect(dbhost, dbuser, dbpass, dbname)
     # get server version string and display it
     puts "Server version: " + dbh.get_server_info + "\n"



     users.each{|u|
       uid = nil
       githubuser = GitHubUser.new(u,github)
       followers = githubuser.followers
       followings = githubuser.followings
       location = githubuser.location

	if githubuser.username == nil then
		puts "Skipping to next user because #{u} is not found on github.com\n"
		next
	end       
       
       
       
       if github.is_user_in_db(u,dbh) then
         puts "User #{u} already in the DB, no action needed\n"
         uid = github.get_id_from_user(u,dbh)
       else
         puts "Adding new user to DB: #{u}"
         uid = github.add_user_to_db(githubuser, dbh)
       end
       
       
       
       # process followers
       if followers != nil then
            followers.each{|f|
                  fid = nil
                  follower = GitHubUser.new(f,github)
                  
                  if github.is_user_in_db(follower.username, dbh) then
                        if fid = github.get_id_from_user(follower.username, dbh) then
                          nil
                        else
                          puts "SEVERE ERROR IN DB with User: #{f}"
                          break 
                        end
                  else
                        fid = github.add_user_to_db(follower, dbh)
                  end
                  
                  puts "Add Follower #{follower.username} -> #{u}\n"
                  github.add_edge(fid, uid, dbh)
             
             }
        end
       
       # process followings
       if followings != nil then
              fid = nil
              puts "Followings for #{u}: #{followings}\n"
              followings.each{|f|
                  following = GitHubUser.new(f,github)
                  if github.is_user_in_db(following.username , dbh) then
                    if fid = github.get_id_from_user(following.username, dbh) then
                      nil
                    else
                      puts "SEVERE ERROR IN DB with User: #{f}"
                      break
                    end
                  else
                    fid = github.add_user_to_db(following, dbh)
                  end
                  
                    puts "Add Following #{u} -> #{following.username}\n"
                    github.add_edge(uid, fid, dbh)
                  
                  }
         end
    }
       
       
  rescue Mysql::Error => e
     puts "Error code: #{e.errno}"
     puts "Error message: #{e.error}"
     puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
   ensure
     # disconnect from server
     dbh.close if dbh
end
       
