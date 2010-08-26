require 'rubygems'
require 'githubapi'
require 'objectstash'
require 'igraph'


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