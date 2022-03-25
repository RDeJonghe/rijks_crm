desc 'Run Tests'
task :test do
  sh 'ruby test/rijks_crm_test.rb'
end

desc 'Push to Git'
task :git do
  sh 'git add --all'
  sh "git commit -m 'rake'"
  sh 'git push -u origin main'
end

desc 'Push Merged Branch to Git'
  task :git_push_branch
  sh 'git push -u origin main'
end

desc 'Rubocop Main File'
task :cop do
  sh 'rubocop rijks_crm.rb'
end

desc 'Rubocop Test File'
task :cop_test do
  sh 'rubocop test/rijks_crm_test.rb'
end

desc 'Rubocop Rake File'
task :cop_rake do
  sh 'rubocop Rakefile'
end

desc 'Default Is Run Tests'
# rubocop:disable Style/HashSyntax
task :default => [:test]
# rubocop:enable Style/HashSyntax
