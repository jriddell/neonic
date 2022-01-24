#!/usr/bin/ruby

require 'net/http'
require 'uri'
require 'json'

groups_kde = ['kde', 'qt', 'extras', 'mobile', 'neon-packaging']
groups = ['backports-focal', 'forks', '3rdparty', 'neon']
groups_all = groups_kde + groups

repo_list = open("REPO-LIST").readlines

def get_repos(group, repo_list)
  puts "group"
  puts group
  repos = repo_list.select {|repo| repo.match(":neon/" + group + "/")}
  repos = repos.collect{ |repo| repo.match(/neon\/.*\/(.*).git/)[1] }
  repos.sort
end

groups_all.each do |group|
    repos = get_repos(group, repo_list)
    #puts repos
    begin
      Dir.mkdir(group)
    rescue
      puts "already exists dir " + group
    end
    Dir.chdir(group) do
      repos.each do |repo|
        begin
          Dir.mkdir(repo)
        rescue
          puts "already exists repo dir " + repo
        end
        Dir.chdir(repo) do
          begin
            Dir.mkdir("neongit")
          rescue
            puts "already exists neongit dir " + repo
          end
          Dir.chdir("neongit") do
            system("git clone git@invent.kde.org:neon/" + group + "/" + repo + ".git")
          end
          if groups_kde.include?(group)
            begin
              Dir.mkdir("kdegit")
            rescue
              puts "already exists kdegit dir " + repo
            end
            Dir.chdir("kdegit") do
              begin
                uri = URI("https://projects.kde.org/api/v1/find?id=" + repo)
                json = Net::HTTP.get(uri)
                result = JSON(json)
                system("git clone git@invent.kde.org:" + result[0] + ".git")
              rescue
                puts "could not clone kde repo for " + repo
              end
            end
          end
        end
      end
    end
end

