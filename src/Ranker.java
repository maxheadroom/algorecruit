import java.util.HashMap;
import java.util.List;
import java.util.Map;

import edu.uci.ics.jung.algorithms.importance.RandomWalkBetweenness;
import edu.uci.ics.jung.algorithms.scoring.HITS;
import edu.uci.ics.jung.algorithms.scoring.KStepMarkov;
import edu.uci.ics.jung.graph.DirectedSparseGraph;
import edu.uci.ics.jung.graph.Graph;
import edu.uci.ics.jung.graph.util.EdgeType;

public class Ranker {
    public Map<String, Double> rank(Map network) throws Exception {
        Graph<String, Integer> g = new DirectedSparseGraph<String, Integer> ();
        int count = 0;
        for(Object e : network.entrySet()) {
            Map.Entry entry = (Map.Entry)e;
            String user = (String)entry.getKey();
            List follows = (List)entry.getValue();
            for(Object fuser : follows) {
                g.addEdge(count,user,(String)fuser,EdgeType.DIRECTED);
                count++;
            }
        }


			edu.uci.ics.jung.algorithms.importance.BetweennessCentrality<String, Integer> ranker = new edu.uci.ics.jung.algorithms.importance.BetweennessCentrality<String, Integer>(g);
			ranker.step();
			// System.out.println("RankScoreKey: " + ranker.getRankScoreKey());
			ranker.setMaximumIterations(100);
			ranker.setRemoveRankScoresOnFinalize(false);
			ranker.evaluate();
		
        HashMap<String,Double> result = new HashMap<String,Double>();
        for(String v : g.getVertices()) {
            result.put(v,ranker.getVertexRankScore(v));
			// System.out.println("Score for " + v + " = " + ranker.getVertexRankScore(v)); 
        }
        return result;
	
        
    }



    public Map<String, Double> BetweenessCentralityScoring(Map network) throws Exception {
        Graph<String, Integer> g = new DirectedSparseGraph<String, Integer> ();
        int count = 0;
        for(Object e : network.entrySet()) {
            Map.Entry entry = (Map.Entry)e;
            String user = (String)entry.getKey();
            List follows = (List)entry.getValue();
            for(Object fuser : follows) {
                g.addEdge(count,user,(String)fuser,EdgeType.DIRECTED);
                count++;
            }
        }
        
			edu.uci.ics.jung.algorithms.scoring.BetweennessCentrality<String, Integer> ranker = new edu.uci.ics.jung.algorithms.scoring.BetweennessCentrality<String, Integer>(g);
			
		// System.out.println("BetweenessCentralityScoring: \n");
        HashMap<String,Double> result = new HashMap<String,Double>();
        for(String v : g.getVertices()) {
            result.put(v,ranker.getVertexScore(v));
			// System.out.println("Score for " + v + " = " + ranker.getVertexScore(v)); 
        }
        return result;
	
        
    }



	public Map<String, Double> markovRank(Map network) throws Exception {
        Graph<String, Integer> g = new DirectedSparseGraph<String, Integer> ();
        int count = 0;
        for(Object e : network.entrySet()) {
            Map.Entry entry = (Map.Entry)e;
            String user = (String)entry.getKey();
            List follows = (List)entry.getValue();
            for(Object fuser : follows) {
                g.addEdge(count,user,(String)fuser,EdgeType.DIRECTED);
                count++;
            }
        }
        

        KStepMarkov<String, Integer> mkpr = new KStepMarkov<String, Integer>(g, 5);
		mkpr.setCumulative(false);
		mkpr.evaluate();
		HashMap<String,Double> resultmk = new HashMap<String,Double>();
        for(String v : g.getVertices()) {
            resultmk.put(v,mkpr.getVertexScore(v));
        }
        return resultmk;

    }

	public HashMap<String, HashMap> HITSRank(Map network) throws Exception {
        Graph<String, Integer> g = new DirectedSparseGraph<String, Integer> ();
        int count = 0;
        for(Object e : network.entrySet()) {
            Map.Entry entry = (Map.Entry)e;
            String user = (String)entry.getKey();
            List follows = (List)entry.getValue();
            for(Object fuser : follows) {
                g.addEdge(count,user,(String)fuser,EdgeType.DIRECTED);
                count++;
            }
        }
        
	
        HITS<String, Integer> mkpr = new HITS<String, Integer>(g);


		mkpr.evaluate();
		
		
		HashMap<String,Double> resultauth = new HashMap<String,Double>();
		HashMap<String,Double> resulthub = new HashMap<String,Double>();
        for(String v : g.getVertices()) {
			// System.out.printf("User %s = Auth( %8.5f ) + Hub( %8.5f ) \n", v , mkpr.getVertexScore(v).authority, mkpr.getVertexScore(v).hub );
			resulthub.put(v,mkpr.getVertexScore(v).hub);
			resultauth.put(v,mkpr.getVertexScore(v).authority);
        }
		HashMap<String,HashMap> result = new HashMap<String,HashMap>();
		result.put("hub",resulthub);
		result.put("authority", resultauth);
        return result;

    }


}

