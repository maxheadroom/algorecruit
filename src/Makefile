MYSQLOPTS := mysql -uruby -pruby algorecruit

all: berlin london tokyo leipzig sanfrancisco

berlin:
	echo "Importing Berlin"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < berlin.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)

london:
	echo "Importing London"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < london.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)

tokyo:
	echo "Importing Tokyo"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < tokyo.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)

leipzig:
	echo "Importing Leipzig"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < leipzig.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)

sanfrancisco:
	echo "Importing San Francisco"
	@echo "truncate table github_edges; truncate table github_users;" | $(MYSQLOPTS)
	@$(MYSQLOPTS) < san_francisco.sql 
	@echo "SELECT count(*) AS Users from github_users;" | $(MYSQLOPTS)
	@echo "SELECT count(*) AS Edges from github_edges;" | $(MYSQLOPTS)

test:
	export CLASSPATH=`echo lib/*jar | tr ' ' :`:.
	export PATH=$PATH:/Users/fzurell/jruby-1.5.0.RC3/bin
	jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null; jruby rank.rb > /dev/null
