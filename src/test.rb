#!/usr/bin/env ruby

# Author::    Falko Zurell  (mailto:falko.zurell@gmail.com)
# Copyright:: Copyright (c) 2010 Falko Zurell
# License::   GNU FDL

require 'GithubAPI'
require 'yaml'
# require 'rgl/adjancency'
require 'rgl/adjacency'
require 'rgl/dot'

dg = RGL::DirectedAdjacencyGraph.new(edgelist_class = Set)

config = YAML.load_file("authconfig.yml")


github = GithubAPI.new(config["user_name"], config["token"])


root_user = "mattb"

# add the initial user to the Graph
dg.add_vertex(root_user)





myuser = github.get_userinfo(root_user)

myuser.each_key { |k|
  printf("%s : %s\n", k, myuser[k])
  }

followings = github.get_followings(root_user)['users']

printf("\n=========== Following count: %i ===========\n\n", followings.length)

followings.each { |k|
  # add the following to the graph
  dg.add_vertex(k)
  # add the edge to the graph
  dg.add_edge(root_user, k)

  printf("Following: %s \n", k)
  }
  
  
followers = github.get_followers(root_user)['users']

printf("\n=========== Follower count: %i ===========\n\n", followers.length)
followers.each { |k|
  
  # add the following to the graph
  dg.add_vertex(k)
  # add the edge to the graph
  dg.add_edge(k,root_user)
  
    printf("Follower: %s \n", k)
    }
    
    
# Print some graph stats

printf("Some stats about %s\n", root_user )
printf("Graph has %i number of edges\n", dg.num_edges)    
printf("Graph has %i number of vertices\n", dg.num_vertices)    
dg.write_to_graphic_file('jpg')