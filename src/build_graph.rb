require 'rubygems'
require 'net/http'
require 'yaml'
require 'cgi'
require 'bossman'
include BOSSMan
require 'mysql'
require 'githubapi'
require 'rgl/adjacency'
require 'rgl/dot'


$stdout.sync = true
config = YAML.load_file("authconfig.yml")
BOSSMan.application_id = config["token"]
github = GithubAPI.new(config["user_name"], config["token"])

dg = RGL::DirectedAdjacencyGraph.new(edgelist_class = Set)

github = GithubAPI.new(config["user_name"], config["token"])


####### mysql #########
begin
     # connect to the MySQL server
     dbh = Mysql.real_connect("localhost", "ruby", "ruby", "algorecruit")
     
     users = dbh.query("SELECT * FROM github_users")
     
     users.each_hash {|row|
        user = row["username"]
        followers = row["followers"]
        followings = row["followings"]
       
       dg.add_vertex(user)
       
       dg = github.add_followers_to_graph( user, followers, dg )
       dg = github.add_followings_to_graph( user, followings, dg )
       }
       
       printf("Graph has %i number of edges\n", dg.num_edges)    
       printf("Graph has %i number of vertices\n", dg.num_vertices)    
       dg.write_to_graphic_file('jpg')
     
   rescue Mysql::Error => e
     puts "Error code: #{e.errno}"
     puts "Error message: #{e.error}"
     puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
   ensure
     # disconnect from server
     dbh.close if dbh
end