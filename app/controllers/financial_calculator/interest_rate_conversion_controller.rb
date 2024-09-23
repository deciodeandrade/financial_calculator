module FinancialCalculator
  class InterestRateConversionController < ApplicationController
    # POST /financial_calculator/interest_rate_conversion
    def convert
      service = FinancialCalculator::InterestRateConversionService.new(conversion_params)
      result = service.convert

      if service.valid?
        render json: result, status: :ok
      else
        render json: { error: service.errors }, status: :unprocessable_entity
      end
    end

    private

    # Define os parâmetros permitidos
    def conversion_params
      params.permit(:original_rate, :original_period, :target_period)
    end
  end
end
