require 'activemerchant'
require 'active_merchant_sage_pay_3d_secure/active_merchant/billing/response'
require 'active_merchant_sage_pay_3d_secure/active_merchant/billing/gateways/sage_pay'

# Extending classes based on the pattern described at:
# http://www.justinweiss.com/articles/3-ways-to-monkey-patch-without-making-a-mess/
#
# "This way, you can organize related monkey patches together. When there’s an 
# error, it’s clear exactly where the problem code came from. And you can
# include them one group at a time"

ActiveMerchant::Billing::Response.include(
  ActiveMerchantSagePay3dSecure::ActiveMerchant::Billing::Response
)

ActiveMerchant::Billing::SagePayGateway.include(
  ActiveMerchantSagePay3dSecure::ActiveMerchant::Billing::SagePayGateway
)
