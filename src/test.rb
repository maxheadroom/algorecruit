#!/usr/bin/env ruby

require 'GithubAPI'
require 'yaml'

config = YAML.load_file("authconfig.yml")
user_name = config["user_name"]
token = config["token"]

github = GithubAPI.new(user_name, token)

myuser = github.get_userinfo("mattb")
myuser.each_key { |k|
  printf("%s : %s\n", k, myuser[k])
  }

printf("%s", myuser.class)