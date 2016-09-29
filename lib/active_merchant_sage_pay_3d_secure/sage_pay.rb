module ActiveMerchantSagePay3dSecure
  # Module to be included in ActiveMerchant::Billing::SagePayGateway. It relies
  # heavily on the ActvieMerchant implementation and contrary to best practices
  # also on private methods.
  #
  # The reason is that ActiveMerchant::Billing::SagePayGateway doesn't provide
  # and easy to to extend and reuse.
  module SagePay
    def authenticate_3d_secure(md, pares, options)
      requires!(options, :order_id)

      # VendorTxCode is required for capture authorization
      parameters = {}
      add_pair(parameters, :VendorTxCode, sanitize_order_id(options[:order_id]), required: true)

      authorization_results = post_data_3d_authorization_results(
        MD: md,
        PARes: pares
      )

      response = parse(
        ssl_post(url_with_3d_secure_endpoint, authorization_results)
      )

      ActiveMerchant::Billing::Response.new(
        response["Status"] == self.class::APPROVED,
        message_from(response),
        response,
        build_response_options(response, parameters)
      )
    end

    private

    def build_response_options(response, parameters)
      authorization_string =
        authorization_from(response, parameters, :authenticate_3d_secure)

      {
        test: test?,
        authorization: authorization_string,
        avs_result: {
          street_match: avs_cvv_code[response['AddressResult']],
          postal_match: avs_cvv_code[response['PostCodeResult']],
        },
        cvv_result: avs_cvv_code[response['CV2Result']]
      }
    end

    def url_with_3d_secure_endpoint
      "#{gateway_service_url}/direct3dcallback.vsp"
    end

    def gateway_service_url
      test? ? self.test_url : self.live_url
    end

    def post_data_3d_authorization_results(parameters)
      parameters.collect { |key, value|
        "#{key}=#{CGI.escape(value.to_s)}"
      }.join("&")
    end

    def avs_cvv_code
      self.class::AVS_CVV_CODE
    end
  end
end
