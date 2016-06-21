require 'test_helper'

class SagePayTest < Test::Unit::TestCase
  # include CommStub

  def setup
    @gateway = SagePayGateway.new(login: 'X')

    @credit_card = credit_card('4242424242424242', brand: 'visa')
    @options = {
      :billing_address => {
        :name => 'Tekin Suleyman',
        :address1 => 'Flat 10 Lapwing Court',
        :address2 => 'West Didsbury',
        :city => "Manchester",
        :county => 'Greater Manchester',
        :country => 'GB',
        :zip => 'M20 2PS'
      },
      :order_id => '1',
      :description => 'Store purchase',
      :ip => '86.150.65.37',
      :email => 'tekin@tekin.co.uk',
      :phone => '0161 123 4567'
    }
    @amount = 100
  end

  def test_authentication_3d_secure_response_purchase
    @gateway.expects(:ssl_post).returns(authentication_3d_secure_response)

    assert response = @gateway.purchase(@amount, @credit_card, @options)
    assert_equal true, response.authentication_3d_secure?
    assert_equal false, response.success?
  end

  def test_successful_authenticate_3d_secure
  end

  def test_unsuccessful_authenticate_3d_secure
  end

  def test_authenticate_3d_secure_url
    binding.pry
    assert_equal(
      'https://test.sagepay.com/gateway/service/direct3dcallback.vsp',
      @gateway.send(:url_for, :authenticate_3d_secure)
    )
  end

  # Verify that purchase url is unchanged
  # def test_purchase_url
  #   assert_equal(
  #     'https://test.sagepay.com/gateway/service/vspdirect-register.vsp',
  #     @gateway.send(:url_for, :purchase)
  #   )
  # end

  # # Verify that capture url is unchanged
  # def test_capture_url
  #   assert_equal(
  #     'https://test.sagepay.com/gateway/service/release.vsp',
  #     @gateway.send(:url_for, :capture)
  #   )
  # end

  private

  def authentication_3d_secure_response
    <<-TRANSCRIPT
VPSProtocol=3.00
Status=3DAUTH
StatusDetail=2007 : Please redirect your customer to the ACSURL, passing the MD and PaReq.
3DSecureStatus=OK
MD=20146540558406021921
ACSURL=https://test.sagepay.com/mpitools/accesscontroler?action=pareq
PAReq=eJxVUtFugjAUfd9XEF6XcNsOEM21xqGJZtORucS9ktIpmYAWGPr3axGma0JyzunltPfc4uScHawfqcq0yMc2dYg94Q/4sVdSzjZS1EpyXMmyjHfSSpOxzQh1fc8lnhe4xCeMDhm1OUbTd3ni2Blx7eNQhJ5qByX2cV5xjMXpebnm7pANCUHoKGZSLWfcJfTJZQPSLYSrjHmcSR7GKrnoz3qtEoRWQlHUeaUuPGA+Qk+wVge+r6rjCKBpGkd0PzqicOpvBLONcLtSVBtUartzmvCv2VuQPr58epAvwt0qnDfbxXo73w1cMkYwFZjEleQ6CF8HEFg0GBF/xFyEVsc4M/fgtG3vivFojpjebdwLqFNWMhd9Gz1DeT4WudQVDOEPYyJLwTdmHlF8sVbRUh9sJIRbI+HCJC0qHR41IbfI+KU6HzogfmtoCIKphW5+0I1ao39P4Bct97JF
    TRANSCRIPT
  end
end
