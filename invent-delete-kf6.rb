#!/usr/bin/ruby

require 'gitlab'

require_relative 'invent-setup'

projects = Gitlab.group("7404").projects(per_page: 500)
projects.each do |project|
  if project.name.start_with?('kf6-')
    puts project.name
    puts project.id
    puts project["name_with_namespace"]
    #g.delete_project(project.id)
  end
end
