module FinancialCalculator
  class AmortizationController < ApplicationController
    # POST /financial_calculator/amortization
    def calculate
      service = FinancialCalculator::AmortizationService.new(amortization_params)
      result = service.calculate

      if service.valid?
        render json: result, status: :ok
      else
        render json: { error: service.errors }, status: :unprocessable_entity
      end
    end

    private

    # Define os parâmetros permitidos
    def amortization_params
      params.permit(:loan_amount, :interest_rate, :period, :amortization_type)
    end
  end
end
