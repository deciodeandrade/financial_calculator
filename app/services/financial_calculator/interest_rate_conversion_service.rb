module FinancialCalculator
  class InterestRateConversionService
    attr_reader :original_rate, :original_period, :target_period, :errors

    PERIODS_IN_YEAR = {
      'daily' => 365,
      'monthly' => 12,
      'quarterly' => 4,
      'semiannually' => 2,
      'annually' => 1
    }.freeze

    def initialize(params)
      @original_rate = params[:original_rate].to_f
      @original_period = params[:original_period].downcase
      @target_period = params[:target_period].downcase
      @errors = {}
    end

    # Executa a conversão de taxa
    def convert
      return unless valid?

      # Converter a taxa para taxa anual efetiva
      annual_rate = case original_period
                    when 'daily'
                      (1 + original_rate) ** PERIODS_IN_YEAR['daily'] - 1
                    when 'monthly'
                      (1 + original_rate) ** PERIODS_IN_YEAR['monthly'] - 1
                    when 'quarterly'
                      (1 + original_rate) ** PERIODS_IN_YEAR['quarterly'] - 1
                    when 'semiannually'
                      (1 + original_rate) ** PERIODS_IN_YEAR['semiannually'] - 1
                    when 'annually'
                      original_rate
                    else
                      0
                    end

      # Converter a taxa anual para a taxa alvo
      converted_rate = case target_period
                      when 'daily'
                        (1 + annual_rate) ** (1.0 / PERIODS_IN_YEAR['daily']) - 1
                      when 'monthly'
                        (1 + annual_rate) ** (1.0 / PERIODS_IN_YEAR['monthly']) - 1
                      when 'quarterly'
                        (1 + annual_rate) ** (1.0 / PERIODS_IN_YEAR['quarterly']) - 1
                      when 'semiannually'
                        (1 + annual_rate) ** (1.0 / PERIODS_IN_YEAR['semiannually']) - 1
                      when 'annually'
                        annual_rate
                      else
                        0
                      end

      {
        converted_rate: converted_rate.round(4)  # Exemplo: 0.2682 para 26,82% ao ano
      }
    end

    # Valida os parâmetros de entrada
    def valid?
      validate_original_rate
      validate_original_period
      validate_target_period
      @errors.empty?
    end

    private

    def validate_original_rate
      if original_rate < 0
        @errors[:original_rate] = "Deve ser uma taxa não negativa."
      end
    end

    def validate_original_period
      unless PERIODS_IN_YEAR.key?(original_period)
        @errors[:original_period] = "Período original inválido. Use 'daily', 'monthly', 'quarterly', 'semiannually' ou 'annually'."
      end
    end

    def validate_target_period
      unless PERIODS_IN_YEAR.key?(target_period)
        @errors[:target_period] = "Período alvo inválido. Use 'daily', 'monthly', 'quarterly', 'semiannually' ou 'annually'."
      end
    end
  end
end
