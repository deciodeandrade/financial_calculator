module FinancialCalculator
  class CompoundInterestController < ApplicationController
    # POST /financial_calculator/compound_interest
    def calculate
      service = FinancialCalculator::CompoundInterestService.new(compound_interest_params)
      result = service.calculate

      if service.valid?
        render json: result, status: :ok
      else
        render json: { error: service.errors }, status: :unprocessable_entity
      end
    end

    private

    # Define os parâmetros permitidos
    def compound_interest_params
      params.permit(:initial_capital, :interest_rate, :period)
    end
  end
end
