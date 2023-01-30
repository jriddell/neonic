#!/usr/bin/ruby

require 'gitlab'

require_relative 'invent-setup'

Gitlab.create_project(ARGV[0], { namespace_id: "7404" })
puts "#{ARGV[0]} created"
