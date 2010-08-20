#!/usr/bin/ruby
# from http://www.columbia.edu/~jbl2132/graph_jbl.rb
#
require 'rubygems'
require 'net/http'
require 'yaml'
require 'cgi'
require 'bossman'
include BOSSMan
require 'igraph'

$stdout.sync = true
puts "Getting URLs"
config = YAML.load_file("authconfig.yml")

BOSSMan.application_id = config["token"]


offset = 0
done = false
urls = []
while !done
    results = BOSSMan::Search.web('site:github.com location "' + ARGV[0] + '" "profile - github"', :start => offset)
    offset += results.count.to_i
    if offset > results.totalhits.to_i
        done = true
    end
    urls += results.results.map { |r| r.url }
end

# this will become the graph
next_v_id = 1
v_to_id = { }
id_to_v = { }
edges = [ ]

puts "Getting social graph"
graph = {}
Net::HTTP.start('github.com') { |http|
    for line in urls
        sleep 1
        line.match(/github.com\/([a-zA-Z0-9-]+)/)
        me = $1
        if me.match(/^(.*)\/$/)
            me = $1
        end
        url = "/api/v2/yaml/user/show/#{me}/followers"
        puts url
        req = Net::HTTP::Get.new(url)
        response = http.request(req)
        case response 
        when Net::HTTPSuccess
            graph[me] = []
            for link in YAML.load(response.body)["users"]
                graph[me] << link
				#puts "\"#{me}\",\"#{link}\""
			
				# add this link to the graph
				v_arr = [me, link]
				v_arr.each do |cur_v|
					if v_to_id[cur_v]
						cur_id = v_to_id[cur_v]
					else
						cur_id = next_v_id
						v_to_id[cur_v] = cur_id
						id_to_v[cur_id] = cur_v
						next_v_id = next_v_id + 1
					end
			
					edges.push(cur_id)
				end

            end
        else
            puts "non-200: #{me}"
        end
    end
}


#build the graph and do some processing
g = IGraph.new(edges,true)
vs = g.vertices

#max = vs.zip(g.degree(vs,IGraph::ALL,true)).max{|a,b| a[1] <=> b[1]}
#puts "Maximum degree is      #{sprintf("%10i",max[1])}, vertex #{max[0]}, id #{id_to_v[max[0]]}."
#
#max = vs.zip(g.closeness(vs,IGraph::ALL)).max{|a,b| a[1] <=> b[1]}
#puts "Maximum closeness is   #{sprintf("%10f",max[1])}, vertex  #{max[0]}, id #{id_to_v[max[0]]}."

max = vs.zip(g.betweenness(vs,IGraph::ALL)).max{|a,b| a[1] <=> b[1]}
puts "Maximum betweenness is #{sprintf("%10f",max[1])}, vertex  #{max[0]}, id #{id_to_v[max[0]]}."

sorted_list = vs.zip(g.betweenness(vs,IGraph::ALL)).sort{|a,b| b[1] <=> a[1]}
for i in (1..20)
	puts "##{i}: #{id_to_v[sorted_list[i-1][0]]}"
end
