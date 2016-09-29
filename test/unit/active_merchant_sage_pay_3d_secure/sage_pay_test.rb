require 'test_helper'

# rubocop:disable ClassLength
# :reek:InstanceVariableAssumption
class SagePayTest < Test::Unit::TestCase
  def setup
    @gateway = SagePayGateway.new(login: 'X')
    @credit_card = credit_card('4242424242424242', brand: 'visa')
    @options = payment_options
    @amount = 199
  end

  def test_authorization_requires_3d_secure_authentication
    @gateway.expects(:ssl_post).returns(require_3d_secure_response)

    assert response = @gateway.authorize(@amount, @credit_card, @options)
    assert_equal true, response.authentication_3d_secure?
    assert_equal false, response.success?
  end

  def test_successful_authenticate_3d_secure
    @gateway.expects(:ssl_post).returns(successful_authorize_response)

    assert response = @gateway.authenticate_3d_secure(md, pares, @options)
    assert_equal(
      '1fda9328;{C45EF786-0E62-8DF5-807F-991E6581F642};12625153;NUGYUZ3Z1D;' \
      'authenticate_3d_secure',
      response.authorization
    )
    assert response.success?
  end

  def test_unsuccessful_authenticate_3d_secure
    @gateway.expects(:ssl_post).returns(unsuccessful_authorize_response)

    assert response = @gateway.authenticate_3d_secure(md, pares, @options)
    assert !response.success?
  end

  def test_3d_secure_parameters_are_submitted
    @gateway.expects(:ssl_post).with(
      'https://test.sagepay.com/gateway/service/direct3dcallback.vsp',
      "MD=#{md}&PARes=#{CGI.escape(pares)}"
    ).returns(successful_authorize_response)
    @gateway.authenticate_3d_secure(md, pares, @options)
  end

  def test_authenticate_3d_secure_callback_url
    @gateway.authenticate_3d_secure(md, pares, @options)
    assert_equal(
      'https://test.sagepay.com/gateway/service/direct3dcallback.vsp',
      @gateway.send(:url_with_3d_secure_endpoint)
    )
  end

  private

  def payment_options
    {
      billing_address: billing_address,
      order_id: '1fda9328',
      description: 'Ccquiring goods',
      ip: '96.102.184.4',
      email: 'donald.draper@mad.co.uk',
      phone: '01632 960 316'
    }
  end

  def billing_address
    {
      name: 'Donald Draper',
      address1: '10 Downing Street',
      city: 'LONDON',
      country: 'GB',
      zip: 'SW1A 2AA'
    }
  end

  def md
    '2014750827668926811'
  end

  # rubocop:disable LineLength
  def pares
    'eJylV1lzokoUfvdXpJxHK2EREVLEW82iYkQFEZU3hJZFBKVZ/fUXjYmZzNxbE4cqi+7jWb7v9DndNPdPuQ8fcpggP45emsQT3nyAkR07fuS+NBd6/5Fp/tNrcLqXQCjOoZ0lsMcpECHLhQ++89IkcYLqdnCG7NI0w5I0QxDNHjcDGkSX/w9WAtEz/sR2GZql8E6XxOsXzdRK17C9OuoTwWHv09p9YntWlPY4yz7y8qRHsSSL4xx2nXJ7mMhij8KJNkV28evDYW9iDrvZz7LzCNWQS9/pyW1nCqEfKDKEWg7QJiPn3cXW3CfohcPOGpxjpbBXU6JxlmQeCOaZIJ8pmsMucu5wdgf2cVb7plm6DvlZwtXJSerkVT2GrE0+ZhwsD3EEaw2Swz7GHHYDd7CiK8e3p7Y+izh91eNSf/8Log7FYRc5h1IrzVBvzWHXEWdbed4DAPBA0zq7Anx9aqYXFQ7afg/v1Ijq98UKhG6c+Km3P+P8WcBhZyjYZVXrJKHnue9GdbwEPtT1E6FnB700vTQ9PGNYURRPRfspTlyMrLlgOIvVOg7y3R/NupKuxtCRo218j7VgRXHk21bon6y0rhcFpl7sPHyA/Z0rXTt7IzBNEh5rd482QUWPZwneJjrN76HAbiQuGfiT+F+dJMh6RJ5F3Bdag1t4Li34sNDkl+Y3nbz50BMrQts42aO/sv4ebRjlMIwP0HlE79m7LwN/GP9/l/3HsjYT4v2+7kZ0Bwzspyy+4RJ9F6L0noq4vxreYhpWmH23GQs0tbNhRz2d1rt0E1n7+Y5djVFg7YuXC71Prq+EP0rvOr+18peuuAdPA+ZsC5vGbIijDVLC/euR2PAra0cPMn/vHrvwUBahvuxjiWMom/wkiKRod+FR9+kEVwRBH68661IuhWGwbJyyihJ8LWRXbO6XlLcomeBodjXsFOh5uzWCdn9o6FCeGYQndHn5hB27HTfegjYhjDv0QLZV3YxWGzozjcbezUcem/Fj53VPZvYiRMXLLQM3xm9ZeIXVvbvbqoOzopVa99oKMEn9bb09pt/OviLLwkQXBGDSLihkHgBZUsHCNAMw4d3d0dv5A7bAeaAu+kDkt4qKCkFdi4aqDqRiZMxP0kwB+AAQC6kh8MpAH7CZWf8+KQ5rxb6hS1MFFBdFwVP6i+Eod4ZuKQVA5d2JwQOkCwZfbdoaJUuE2ph/MgDlh0Ex9OyJIqqFoku4ooNqEqjk8iw7ScUkqDXfZcENbeN3cO9F2/gd3P9C65pMIarr0Wtsyl5uT4Aq8bwKRHeNA0UejBogHvDgtYZkR+RsgJs7T5cogaR1OrTnuO6MqWl/trADWrKsjjhR3MWQMFd2sIpb1XpsdEaYfzSMne2iudpIYkT7BJFMokF767Vm0XQZl2jvqm7H0m0K0+mglZhQsKONOdyB17w/BaZKhm2ilRnL2C3HnVlqyfaKzL2G254JhiXHIBDbU7pVtnzGmJdyCFylLhPpK63+Gy0JBFE7FebTdkbOglkxT9zDbt6oprY4KI6OXxW+MTm0tHxXpRloJ4sjZUQmNHyCUjO8xE6Y1Fp4EssHdKAvoOaRO5bNmWrLH21hma1DxmyA/kDS9e0KQNPK0dQdoSlKgjKctFpbuaKj7vTkSiSYpIlHzwebpVhG/kgT80O/Xxd0vXHsEvlEb5Wclq4N/aWLejfpuS8/GvyuDe5yes/B35grsZOF2bdP7VhUzWq7Zjbaft5XdHe8OcyORjnWJnjuUgtWq2axdkh2Cl7x6tYInWoCg+7ITVe7qPV6MJZaJZQjIfNPx3FjtUSkvXFaQ6pld6xgUFm8IIaHySlgZ8cZnYbUqHLSHVTBkVlQfChaq+2K7hiWL0r5rkXEXrm1WgPRZkZGI/ZdQZnZ3aQ7pMelMZb8xXUlrlTfeEvXD+dvEgcq4C/O3u3fD7LbKlwlv06vx9pPu/zlenG5/Zw/ij/fiv4FSRBQlA=='
  end

  def require_3d_secure_response
    <<-RESP
VPSProtocol=3.00
Status=3DAUTH
StatusDetail=2007 : Please redirect your customer to the ACSURL, passing the MD and PaReq.
3DSecureStatus=OK
MD=20146540558406021921
ACSURL=https://test.sagepay.com/mpitools/accesscontroler?action=pareq
PAReq=eJxVUtFugjAUfd9XEF6XcNsOEM21xqGJZtORucS9ktIpmYAWGPr3axGma0JyzunltPfc4uScHawfqcq0yMc2dYg94Q/4sVdSzjZS1EpyXMmyjHfSSpOxzQh1fc8lnhe4xCeMDhm1OUbTd3ni2Blx7eNQhJ5qByX2cV5xjMXpebnm7pANCUHoKGZSLWfcJfTJZQPSLYSrjHmcSR7GKrnoz3qtEoRWQlHUeaUuPGA+Qk+wVge+r6rjCKBpGkd0PzqicOpvBLONcLtSVBtUartzmvCv2VuQPr58epAvwt0qnDfbxXo73w1cMkYwFZjEleQ6CF8HEFg0GBF/xFyEVsc4M/fgtG3vivFojpjebdwLqFNWMhd9Gz1DeT4WudQVDOEPYyJLwTdmHlF8sVbRUh9sJIRbI+HCJC0qHR41IbfI+KU6HzogfmtoCIKphW5+0I1ao39P4Bct97JF
    RESP
  end

  # rubocop:disable MethodLength
  def successful_authorize_response
    <<-RESP
VPSProtocol=3.00
Status=OK
StatusDetail=0000 : The Authorisation was Successful.
VPSTxId={C45EF786-0E62-8DF5-807F-991E6581F642}
SecurityKey=NUGYUZ3Z1D
TxAuthNo=12625153
AVSCV2=ALL MATCH
AddressResult=MATCHED
PostCodeResult=MATCHED
CV2Result=MATCHED
3DSecureStatus=OK
CAVV=AAABARR5kwAAAAAAAAAAAAAAAAA=
DeclineCode=00
ExpiryDate=0821
BankAuthCode=999777
    RESP
  end

  def unsuccessful_authorize_response
    <<-RESP
VPSProtocol=3.00
Status=REJECTED
StatusDetail=4026 : 3D-Authentication failed. This vendor's rules require a successful 3D-Authentication.
VPSTxId={7F6F3698-9BA3-5DCD-B0A6-1ED298FB9076}
SecurityKey=IMHFZDOJT3
    RESP
  end
end
