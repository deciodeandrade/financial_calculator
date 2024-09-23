Rails.application.routes.draw do
  namespace :financial_calculator do
    post 'compound_interest', to: 'compound_interest#calculate'
    post 'amortization', to: 'amortization#calculate'
    post 'interest_rate_conversion', to: 'interest_rate_conversion#convert'
  end
end
