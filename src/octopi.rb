#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), '..', 'lib', 'octopi')

include Octopi

# Author::    Falko Zurell  (mailto:falko.zurell@gmail.com)
# Copyright:: Copyright (c) 2010 Falko Zurell
# License::   GNU FDL
require 'rubygems'
# require 'octopi'
print "Test"

# user information
u = User.find("maxheadroom")
puts "#{u.name} followed by #{u.followers.join(", ")}, 
following #{u.following.join(", ")}"