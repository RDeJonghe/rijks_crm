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

desc 'All Tasks Except Git'
task :default => [:test]

