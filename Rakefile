#!/usr/bin/env rake
task :default => :ci
task :ci => %i[dump test]

task :dump do
  sh 'vim --version'
end

task :test do
  sh 'bundle exec vim-flavor test'
end
