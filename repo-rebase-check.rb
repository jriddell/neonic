#!/usr/bin/ruby

# script to run over all repos and check that they don't have Neon/*_jammy branches
# or if they (rightly) do the second step needs some adjustments

require 'gitlab'

Gitlab.endpoint = 'https://invent.kde.org/api/v4'

token = File.open('token.text').read
token.chomp!

Gitlab.private_token = token

projects = Gitlab.projects(per_page: 50)

projects.auto_paginate do |project|
  if project.ssh_url_to_repo.include?(':neon/') and not project.ssh_url_to_repo.include?(':neon/snap-packaging')
    #puts project.name
    begin
      branches = Gitlab.branches(project.id)
      branches.auto_paginate do |branch|
        if branch.name.include?('Neon/') and branch.name.include?('_jammy')
          puts project.ssh_url_to_repo + ": " + project.name
          puts branch.name
        end
      end
    rescue Gitlab::Error::NotFound
      puts "Gitlab::Error::NotFound on " + project.name
    end
  end
end
