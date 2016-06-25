module ActiveMerchantSagePay3dSecure
  # Module use to extend an ActiveMerchant::Billing::Response with SagePay
  # specific logic
  module Response
    def authentication_3d_secure?
      params['Status'] == '3DAUTH'
    end
  end
end
