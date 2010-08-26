require 'rubygems'
require 'net/http'
require 'objectstash'

    # load serialized Graph from file
      graph = ObjectStash.load 'theory_of_everything.stash'
      
      scoring = {}
      
      puts("Printing BetweenessCentrality\n")
      result = Java::Ranker.new.rank(graph)
       
           
      result.each{ |u|
        user = u[0]
        value = u[1]
        # github.add_bcscore_2db(user, value, dbh) 
        scoring["#{user}"] = {}
        scoring["#{user}"]["bc"] =  value
        
      }
      
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
          
            
      
        puts format("Header: username & BC & Authority & Hub")
        scoring.sort_by{|user,scores| scores["bc"]}.each {|user, scores| 
                  # github.add_HITS_2db(user, scores["authority"], scores["hub"], dbh) 
          puts format("User: %s & %.5f & %.5f & %.5f", user, scores["bc"], scores["authority"], scores["hub"] )
          }
          
# serialize the Hash with the scoring and write to file
ObjectStash.store scoring, './scoring.stash'
          