#!/usr/bin/env rake
task :default => :ci
task :test => %i[flavor rspec]
task :ci => %i[dump test]

task :dump do
  sh 'vim --version'
end

task :flavor do
  sh 'bundle exec vim-flavor test'
end

task :rspec do
  sh 'rspec'
end
