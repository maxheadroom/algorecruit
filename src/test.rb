#!/usr/bin/env ruby

require 'GithubAPI'
require 'yaml'

config = YAML.load_file("authconfig.yml")


github = GithubAPI.new(config["user_name"], config["token"])

myuser = github.get_userinfo("mattb")

myuser.each_key { |k|
  printf("%s : %s\n", k, myuser[k])
  }

followings = github.get_followings("mattb")['users']

printf("\n=========== Following count: %i ===========\n\n", followings.length)

followings.each { |k|
  printf("Following: %s \n", k)
  }
  
  
followers = github.get_followers("mattb")['users']

printf("\n=========== Follower count: %i ===========\n\n", followers.length)
followers.each { |k|
    printf("Follower: %s \n", k)
    }