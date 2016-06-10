module ActiveMerchantSagePay3dSecure
  module ActiveMerchant #:nodoc:
    module Billing #:nodoc:
      module Response
        def authentication_3d?
          puts "3d_authentication"
        end
      end
    end
  end
end
