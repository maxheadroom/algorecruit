require 'rubygems'
require 'yaml'
require 'mysql'
require 'githubapi'
require 'objectstash'
require 'igraph'


config = YAML.load_file("authconfig.yml")
github = GithubAPI.new(config["user_name"], config["token"])
dbhost = config["dbhost"]
dbuser = config["dbuser"]
dbpass = config["dbpass"]
# we want the DB to be special
dbname = ARGV[0]


# an hash indexed by username containing array of followers
graph = ObjectStash.load './theory_of_everything.stash'

g = IGraph.new([],true)

# push all vertices into the graph
graph.each{|user,follower|
  
    g.add_vertex(user)
  }
  
graph.each{|user,follower|
  
    follower.each{|f|
        g.add_edge(f,user)
      }
  }
  
  
vs = g.vertices


sorted_list = vs.zip(g.betweenness(vs,IGraph::ALL)).sort{|a,b| b[1] <=> a[1]}
for i in (1..20)
	puts "##{i}: #{[sorted_list[i-1][0]]} = #{[sorted_list[i-1][1]]}"
end