require 'bundler/setup'

require 'test/unit'
require 'mocha/test_unit'

require 'pry'
require 'activemerchant_sage_pay_3d_secure'

ActiveMerchant::Billing::Base.mode = :test

if ENV['DEBUG_ACTIVE_MERCHANT'] == 'true'
  require 'logger'
  ActiveMerchant::Billing::Gateway.logger = Logger.new(STDOUT)
  ActiveMerchant::Billing::Gateway.wiredump_device = STDOUT
end

module ActiveMerchant
  # Common test support methods
  module Fixtures
    def default_expiration_date
      @default_expiration_date ||= Date.new((Time.now.year + 1), 9, 30)
    end

    def credit_card(number = '4242424242424242', options = {})
      defaults = {
        number: number,
        month: default_expiration_date.month,
        year: default_expiration_date.year,
        first_name: 'Longbob',
        last_name: 'Longsen',
        verification_value: options[:verification_value] || '123',
        brand: 'visa'
      }.update(options)

      Billing::CreditCard.new(defaults)
    end
  end
end

Test::Unit::TestCase.class_eval do
  include ActiveMerchant::Billing
  include ActiveMerchant::Fixtures
end
