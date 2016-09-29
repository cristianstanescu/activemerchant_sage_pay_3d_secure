require 'rake'
require 'rake/testtask'

# Copied/Kept from ActiveMerchant
task :tag_release do
  system "git tag 'v#{ActiveMerchantSagePay3dSecure::VERSION}'"
  system 'git push --tags'
end

desc 'Run the unit test suite'
task default: 'test:units'
task test: 'test:units'

namespace :test do
  Rake::TestTask.new(:units) do |t|
    t.pattern = 'test/unit/**/*_test.rb'
    t.libs << 'test'
    t.verbose = true
  end

  Rake::TestTask.new(:remote) do |t|
    t.pattern = 'test/remote/**/*_test.rb'
    t.libs << 'test'
    t.verbose = true
  end
end
