#!/usr/bin/env ruby

# Author::    Falko Zurell  (mailto:falko.zurell@gmail.com)
# Copyright:: Copyright (c) 2010 Falko Zurell
# License::   GNU FDL

require 'GithubAPI'
# include 'GithubAPI'
require 'yaml'
# require 'rgl/adjancency'
require 'rgl/adjacency'
require 'rgl/dot'
require 'mysql'

dg = RGL::DirectedAdjacencyGraph.new(edgelist_class = Set)

config = YAML.load_file("authconfig.yml")


github = GithubAPI.new(config["user_name"], config["token"])


root_user = "mattb"

# add the initial user to the Graph
dg.add_vertex(root_user)


####### mysql #########
begin
     # connect to the MySQL server
     dbh = Mysql.real_connect("localhost", "ruby", "ruby", "algorecruit")
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


myuser = github.get_userinfo(root_user)

myuser.each_key { |k|
  printf("%s : %s\n", k, myuser[k])
  }

followings = github.get_followings(root_user)['users']

printf("\n=========== Following count: %i ===========\n\n", followings.length)

dg = github.add_followings_to_graph( root_user, followings, dg )

# followings.each { |k|
#   # add the following to the graph
#   dg.add_vertex(k)
#   # add the edge to the graph
#   dg.add_edge(root_user, k)
# 
#   printf("Following: %s \n", k)
#   }
  
  
followers = github.get_followers(root_user)['users']

printf("\n=========== Follower count: %i ===========\n\n", followers.length)

dg = github.add_followers_to_graph( root_user, followers, dg )
# followers.each { |k|
#   
#   # add the following to the graph
#   dg.add_vertex(k)
#   # add the edge to the graph
#   dg.add_edge(k,root_user)
#   
#     printf("Follower: %s \n", k)
#     }

repos = github.get_public_repos(root_user)
printf("\n=========== public repo count: %i ===========\n\n", repos.size)
    repos.each { |r|
      
      printf("Repository: %s \n", r)
      
      }
    
  
# Print some graph stats

printf("Some stats about %s\n", root_user )
printf("Graph has %i number of edges\n", dg.num_edges)    
printf("Graph has %i number of vertices\n", dg.num_vertices)    
dg.write_to_graphic_file('jpg')
dg.print_dotted_on(params = {}, s = $stdout)



# user = GitHubUser.new("lenalena", github)
# 
# printf("Username: %s \n", user.username)
# 
# user.repos.each { |key,value|
#   
#   printf("Repository: %s \n", key)
#   printf("\t\tLanguages: %s\n", value.languages.to_s)
#   
#   }
# user.followers.each { |f|
#   printf("Follower: %s \n", f)
#   }
#   
# user.followings.each { |f|
#     printf("Following: %s \n", f)
#     }
