module FinancialCalculator
  class CompoundInterestService
    attr_reader :initial_capital, :interest_rate, :period, :errors

    def initialize(params)
      @initial_capital = params[:initial_capital].to_f
      @interest_rate = params[:interest_rate].to_f
      @period = params[:period].to_i
      @errors = {}
    end

    # Executa o cálculo de juros compostos
    def calculate
      return unless valid?

      final_capital = initial_capital * (1 + interest_rate) ** period
      total_interest = final_capital - initial_capital

      {
        final_capital: final_capital.round(2),
        total_interest: total_interest.round(2)
      }
    end

    # Valida os parâmetros de entrada
    def valid?
      validate_initial_capital
      validate_interest_rate
      validate_period
      @errors.empty?
    end

    private

    def validate_initial_capital
      if initial_capital < 0
        @errors[:initial_capital] = "Deve ser um valor não negativo."
      end
    end

    def validate_interest_rate
      if interest_rate < 0
        @errors[:interest_rate] = "Deve ser uma taxa não negativa."
      end
    end

    def validate_period
      if period <= 0
        @errors[:period] = "Deve ser um período positivo."
      end
    end
  end
end
