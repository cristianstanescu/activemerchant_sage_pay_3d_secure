# begin
#   require 'bundler'
#   Bundler.setup
# rescue LoadError => e
#   puts "Error loading bundler (#{e.message}): \"gem install bundler\" for bundler support."
#   require 'rubygems'
# end

require 'rake'
require 'rake/testtask'
# require 'support/gateway_support'
# require 'support/ssl_verify'
# require 'support/outbound_hosts'
# require 'bundler/gem_tasks'

# task :tag_release do
#   system "git tag 'v#{ActiveMerchant::VERSION}'"
#   system "git push --tags"
# end

desc "Run the unit test suite"
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

# namespace :gateways do
  # desc 'Print the currently supported gateways'
  # task :print do
  #   support = GatewaySupport.new
  #   support.to_s
  # end

  # namespace :print do
  #   desc 'Print the currently supported gateways in RDoc format'
  #   task :rdoc do
  #     support = GatewaySupport.new
  #     support.to_rdoc
  #   end

  #   desc 'Print the currently supported gateways in Textile format'
  #   task :textile do
  #     support = GatewaySupport.new
  #     support.to_textile
  #   end

  #   desc 'Print the currently supported gateways in Markdown format'
  #   task :markdown do
  #     support = GatewaySupport.new
  #     support.to_markdown
  #   end

  #   desc 'Print the gateway functionality supported by each gateway'
  #   task :features do
  #     support = GatewaySupport.new
  #     support.features
  #   end
  # end

  # desc 'Print the list of destination hosts with port'
  # task :hosts do
  #   hosts, invalid_lines = OutboundHosts.list

  #   hosts.each do |host|
  #     puts host
  #   end

  #   unless invalid_lines.empty?
  #     puts
  #     puts "Unable to parse:"
  #     invalid_lines.each do |line|
  #       puts line
  #     end
  #   end
  # end

  # desc 'Test that gateways allow SSL verify_peer'
  # task :ssl_verify do
  #   SSLVerify.new.test_gateways
  # end
# end