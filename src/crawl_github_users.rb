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

# extract the usernames from the URLS and put into DB


####### mysql #########
begin
     # connect to the MySQL server
     dbh = Mysql.real_connect("localhost", "ruby", "ruby", "algorecruit")
     # get server version string and display it
     puts "Server version: " + dbh.get_server_info + "\n"


Net::HTTP.start('github.com') { |http|
    for username in users
        
        
        if !github.is_user_in_db(username, dbh) then
            # sleep 1
            url = "/api/v2/yaml/user/show/#{username}/followers"
            puts url
            req = Net::HTTP::Get.new(url)
            response = http.request(req)
            case response 
              when Net::HTTPSuccess
                  followers = []
                  for link in YAML.load(response.body)["users"]
                      followers << link
                  end
              else
                  puts "non-200: #{username}"
            end
            f = followers.join(sep=',')
            dbh.query("INSERT INTO github_users (username, followers) VALUES('#{username}', '#{f}')")
            
            
            #sleep 1
            url = "/api/v2/yaml/user/show/#{username}/following"
            puts url
            req = Net::HTTP::Get.new(url)
            response = http.request(req)
            case response 
              when Net::HTTPSuccess
                  following = []
                  for link in YAML.load(response.body)["users"]
                      following << link
                  end
              else
                  puts "non-200: #{username}"
            end
            
            f = following.join(sep=',')
            dbh.query("UPDATE github_users SET followings = '#{f}' WHERE username='#{username}'")
            
            
      else
        puts "User #{username} already in database \n"
        
      end
        
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
