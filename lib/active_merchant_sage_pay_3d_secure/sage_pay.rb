module ActiveMerchantSagePay3dSecure
  # Module to be included in ActiveMerchant::Billing::SagePayGateway. It relies
  # heavily on the ActvieMerchant implementation and contrary to best practices
  # also on private methods.
  #
  # The reason is that ActiveMerchant::Billing::SagePayGateway doesn't provide
  # and easy to to extend and reuse.
  module SagePay
    include ActiveMerchantSagePay3dSecure::SagePaySupport

    def authenticate_3d_secure(md, pares, options)
      requires!(options, :order_id)

      # VendorTxCode is required for capture authorization
      parameters = {}

      add_pair(
        parameters, :VendorTxCode, sanitize_order_id(options[:order_id]),
        required: true
      )

      active_merchant_response(
        gateway_response(SagePaySupport.build_pairs(MD: md, PARes: pares)),
        parameters
      )
    end

    private

    def build_response_options(response, authorization_string)
      {
        test: test?,
        authorization: authorization_string,
        avs_result: {
          street_match: avs_cvv_code[response['AddressResult']],
          postal_match: avs_cvv_code[response['PostCodeResult']]
        },
        cvv_result: avs_cvv_code[response['CV2Result']]
      }
    end

    def url_with_3d_secure_endpoint
      "#{gateway_service_url}/direct3dcallback.vsp"
    end

    def gateway_service_url
      test? ? test_url : live_url
    end

    def avs_cvv_code
      self.class::AVS_CVV_CODE
    end

    def gateway_response(authorization_results)
      parse(ssl_post(url_with_3d_secure_endpoint, authorization_results))
    end

    def active_merchant_response(response, parameters)
      authorization_string =
        authorization_from(response, parameters, :authenticate_3d_secure)

      ActiveMerchant::Billing::Response.new(
        response['Status'] == self.class::APPROVED,
        message_from(response),
        response,
        build_response_options(response, authorization_string)
      )
    end
  end
end
