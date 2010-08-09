require 'rubygems'
require 'objectstash'


graph = ObjectStash.load 'theory_of_everything.stash'

scoring = {}

puts("Printing BetweenessCentrality\n")
result = Java::Ranker.new.rank(graph)

result.each{ |u|
  user = u[0]
  value = u[1]
  scoring["#{user}"] = {}
  scoring["#{user}"]["bc"] =  value
  
}
#for user in result.sort_by { |user,score| score }
#    
#    puts "\t#{user[0]} \t = \t#{user[1]}"
#end



#puts("Printing MarkovRank\n")
#result = Java::Ranker.new.markovRank(graph)
#for user in result.sort_by { |user,score| score }
#    puts "\t#{user[0]} \t = \t#{user[1]}"
#end

puts("Printing HITS authority + hub\n")
result = Java::Ranker.new.HITSRank(graph)

authority = result["authority"]
hubs = result["hub"]


authority.each{ |u|
  user = u[0]
  value = u[1]
  scoring["#{user}"]["authority"] =  value
}
hubs.each{ |u|
  user = u[0]
  value = u[1]
  scoring["#{user}"]["hub"] =  value
}
    
#  for user in authority.sort_by { |user,score| score }
#      puts "\t#{user[0]} \t = \t#{user[1]} Authority\n"
#  end
#  for user in hubs.sort_by { |user,score| score }
#      puts "\t#{user[0]} \t = \t#{user[1]} Hub\n"
#  end
  
  
  scoring.sort_by{|user,scores| scores["bc"]}.each {|user, scores| 
    
    puts "User: #{user}: BC = #{scores["bc"]} + Authority = #{scores["authority"]} + Hub = #{scores["hub"]}"
    }