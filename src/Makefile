MYSQLOPTS := mysql -uruby -pruby algorecruit

all: berlin london tokyo leipzig sanfrancisco magdeburg wildcard

cleandb:
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)

initdb:
	cat algorecruit.sql | $(MYSQLOPTS)
berlin:
	echo "Importing Berlin"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < berlin.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)
	time ruby dump_db2file.rb
	jruby rank.rb > berlin_full_ranking.txt

magdeburg:
	echo "Importing Magdeburg"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < magdeburg.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)
	time ruby dump_db2file.rb
	jruby rank.rb > magdeburg_full_ranking.txt

london:
	echo "Importing London"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < london.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)
	time ruby dump_db2file.rb
	jruby rank.rb > london_full_ranking.txt

tokyo:
	echo "Importing Tokyo"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < tokyo.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)
	time ruby dump_db2file.rb
	jruby rank.rb > tokyo_full_ranking.txt

leipzig:
	echo "Importing Leipzig"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < leipzig.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)
	time ruby dump_db2file.rb
	jruby rank.rb > leipzig_full_ranking.txt

sanfrancisco:
	echo "Importing San Francisco"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < san_francisco.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)
	time ruby dump_db2file.rb
	jruby rank.rb > sanfrancisco_full_ranking.txt

wildcard:
	echo "Importing wildcard"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < wildcard.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)
	time ruby dump_db2file.rb
	jruby rank.rb > wildcard_full_ranking.txt


test:
	export CLASSPATH=`echo lib/*jar | tr ' ' :`:.
	export PATH=$PATH:/Users/fzurell/jruby-1.5.0.RC3/bin
	time ruby dump_db2file.rb
	jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null
