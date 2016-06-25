module ActiveMerchantSagePay3dSecure  
  module SagePay
    # remove_const ActiveMerchant::Billing::SagePayGateway::TRANSACTIONS

    # ActiveMerchant::Billing::SagePayGateway.const_set('TRANSACTIONS', {
    #   purchase: 'PAYMENT',
    #   credit: 'REFUND',
    #   authorization: 'DEFERRED',
    #   capture: 'RELEASE',
    #   void: 'VOID',
    #   abort: 'ABORT',
    #   store: 'TOKEN',
    #   unstore: 'REMOVETOKEN',
    #   authenticate_3d_secure: 'direct3dcallback'
    # })

    # def initialize(options = {})
    #   self.class::TRANSACTIONS[:authenticate_3d_secure] = 'direct3dcallback'
    #   requires!(options, :login)
    #   super
    # end

    # def authenticate_3d_secure(md, pares)
    #   # post = {}
    #   # add_pair(post, :Currency, currency, required: true)

    #   authorization_results = {
    #     MD: md,
    #     PARes: pares
    #   }

    #   response = parse(
    #     ssl_post(url_with_3d_secure_endpoint, post_data(authorization_results))
    #   )

    #   build_active_merchant_response(
    #     response,
    #     authorization: authorization_from(response, {}, 'authenticate_3d_secure'),
    #   )
    # end

    # response = parse( ssl_post(url_for(action), post_data(action, parameters)) )

    # Response.new(response["Status"] == APPROVED, message_from(response), response,
    #   :test => test?,
    #   :authorization => authorization_from(response, parameters, action),
    #   :avs_result => {
    #     :street_match => AVS_CVV_CODE[ response["AddressResult"] ],
    #     :postal_match => AVS_CVV_CODE[ response["PostCodeResult"] ],
    #   },
    #   :cvv_result => AVS_CVV_CODE[ response["CV2Result"] ]
    # )

    def authenticate_3d_secure(md, pares, options)
      requires!(options, :order_id)

      authorization_results = post_data_3d_authorization_results(
        MD: md,
        PARes: pares
      )

      response = parse(
        ssl_post(url_with_3d_secure_endpoint, authorization_results)
      )

      success = response["Status"] == self.class::APPROVED

      ActiveMerchant::Billing::Response.new(success, message_from(response), response,
        :test => test?,
        :authorization => authorization_from(response, options, :authenticate_3d_secure),
        :avs_result => {
          :street_match => avs_cvv_code[response["AddressResult"]],
          :postal_match => avs_cvv_code[response["PostCodeResult"]],
        },
        :cvv_result => avs_cvv_code[response["CV2Result"]]
      )
    end

    private

    def url_with_3d_secure_endpoint
      "#{gateway_service_url}/direct3dcallback.vsp"
    end

    # TODO: move to ActiveMerchant
    def gateway_service_url
      test? ? self.test_url : self.live_url
    end

    def post_data_3d_authorization_results(parameters)
      parameters.collect { |key, value|
        "#{key}=#{CGI.escape(value.to_s)}"
      }.join("&")
    end

    def avs_cvv_code
      @avs_cvv_code ||= self.class::AVS_CVV_CODE
    end
  end
end
