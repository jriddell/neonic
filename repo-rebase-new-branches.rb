#!/usr/bin/ruby

# script to run over all repos and branch Neon/foo as Neon/foo_jammy and push

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
        if branch.name.include?('Neon/') and (branch.name.end_with?('release') or branch.name.end_with?('stable') or branch.name.end_with?('unstable'))
          puts project.ssh_url_to_repo + ": " + project.name
          puts branch.name
          begin
            Gitlab.create_branch(project.id, branch.name + '_jammy', branch.name)
            puts "Created " + branch.name + '_jammy'
          rescue Gitlab::Error::BadRequest
            puts "Failed to create " + branch.name + '_jammy'
          end
        end
      end
    rescue Gitlab::Error::NotFound
      puts "Gitlab::Error::NotFound on " + project.name
    rescue Gitlab::Error::Forbidden
      puts "Gitlab::Error::Forbidden on " + project.name
    end
  end
end
