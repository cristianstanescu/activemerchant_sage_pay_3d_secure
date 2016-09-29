module ActiveMerchantSagePay3dSecure
  # SagePay support/utility methods to be used by the gateway
  module SagePaySupport
    def self.build_pairs(parameters)
      parameters.collect do |key, value|
        "#{key}=#{CGI.escape(value.to_s)}"
      end.join('&')
    end
  end
end
