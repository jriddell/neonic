#!/usr/bin/ruby

require 'gitlab'

Gitlab.endpoint = 'https://invent.kde.org/api/v4'
Gitlab.private_token = 'x-ajZfXn_NcS1PK87Wez'

projects = Gitlab.projects(per_page: 5)

projects.auto_paginate do |project|
  if project.ssh_url_to_repo.include?(':neon/')
      puts project.ssh_url_to_repo
  end
end
