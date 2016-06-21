Gem::Specification.new do |s|
  s.name = 'activemerchant_sage_pay_3d_secure'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'Enhance ActiveMerchant with support for SagePay 3D Secure'
  s.description = 'Extend ActiveMerchant classes by adding the methods ' \
                  'required to process SagePay 3D Secure requests and responses'
  s.author = 'Cristian Stănescu'
  s.email = 'cristianstanescu@gmail.com'
  s.files = Dir['CHANGELOG', 'README.md', 'LICENSE.md', 'lib/**/*']
  s.homepage =
    'https://github.com/cristianstanescu/active_merchant_sage_pay_3d_secure'
  s.required_ruby_version = '>= 2'

  s.add_runtime_dependency 'activemerchant', '~> 1.59'
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'test-unit', '~> 3'
  s.add_development_dependency 'mocha', '~> 1'
  s.add_development_dependency 'pry'
end
