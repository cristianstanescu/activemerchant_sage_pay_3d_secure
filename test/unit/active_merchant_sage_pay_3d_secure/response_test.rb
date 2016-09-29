require 'test_helper'

# Test additions to ActiveMerchant::Billing::Response
class ResponseTest < Test::Unit::TestCase
  def test_authentication_3d_secure
    response =
      ActiveMerchant::Billing::Response.new(true, 'message', Status: '3DAUTH')
    assert_equal true, response.authentication_3d_secure?
  end

  def test_not_authentication_3d_secure
    response =
      ActiveMerchant::Billing::Response.new(true, 'message', Status: 'OK')
    assert_equal false, response.authentication_3d_secure?
  end
end
