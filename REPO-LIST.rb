#!/usr/bin/ruby

require 'gitlab'

Gitlab.endpoint = 'https://invent.kde.org/api/v4'

token = File.open('token.text').read
token.chomp!

Gitlab.private_token = token

projects = Gitlab.projects(per_page: 50)

projects.auto_paginate do |project|
  if project.ssh_url_to_repo.include?(':neon/')
      puts project.ssh_url_to_repo
  end
end
