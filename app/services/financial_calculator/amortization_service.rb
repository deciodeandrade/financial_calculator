module FinancialCalculator
  class AmortizationService
    attr_reader :loan_amount, :interest_rate, :period, :amortization_type, :errors

    def initialize(params)
      @loan_amount = params[:loan_amount].to_f
      @interest_rate = params[:interest_rate].to_f
      @period = params[:period].to_i
      @amortization_type = params[:amortization_type].upcase
      @errors = {}
    end

    # Executa o cálculo de amortização
    def calculate
      return unless valid?

      case amortization_type
      when "SAC"
        calculate_sac
      when "PRICE"
        calculate_price
      else
        @errors[:amortization_type] = "Tipo de amortização inválido. Use 'SAC' ou 'PRICE'."
        return
      end
    end

    # Valida os parâmetros de entrada
    def valid?
      validate_loan_amount
      validate_interest_rate
      validate_period
      validate_amortization_type
      @errors.empty?
    end

    private

    def validate_loan_amount
      if loan_amount <= 0
        @errors[:loan_amount] = "Deve ser um valor positivo."
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

    def validate_amortization_type
      unless %w[SAC PRICE].include?(amortization_type)
        @errors[:amortization_type] = "Tipo de amortização inválido. Use 'SAC' ou 'PRICE'."
      end
    end

    # Calcula a amortização no sistema SAC
    def calculate_sac
      principal = loan_amount / period
      installments = []
      total_interest = 0
      total_payment = 0

      period.times do |i|
        month = i + 1
        remaining_balance = loan_amount - (principal * i)
        interest = remaining_balance * interest_rate
        total_payment_month = principal + interest

        installments << {
          month: month,
          principal: principal.round(2),
          interest: interest.round(2),
          total_payment: total_payment_month.round(2)
        }

        total_interest += interest
        total_payment += total_payment_month
      end

      {
        installments: installments,
        total_interest: total_interest.round(2),
        total_payment: total_payment.round(2)
      }
    end

    # Calcula a amortização no sistema PRICE
    def calculate_price
      monthly_rate = interest_rate
      denominator = (1 - (1 + monthly_rate) ** -period)
      payment = loan_amount * (monthly_rate / denominator)
      installments = []
      total_interest = 0
      total_payment = 0

      period.times do |i|
        month = i + 1
        interest = loan_amount * monthly_rate
        principal_payment = payment - interest
        loan_amount -= principal_payment

        installments << {
          month: month,
          principal: principal_payment.round(2),
          interest: interest.round(2),
          total_payment: payment.round(2)
        }

        total_interest += interest
        total_payment += payment
      end

      {
        installments: installments,
        total_interest: total_interest.round(2),
        total_payment: total_payment.round(2)
      }
    end
  end
end
