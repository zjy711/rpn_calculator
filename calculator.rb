class Calculator
  def initialize
    @values = []
  end

  def execute(input)
    return if ignore?(input)

    if is_operator?(input)
      execute_operation(input)
    else
      @values << input.to_f
      @values.last
    end
  end

  def ignore?(input)
    input.empty? || !(is_operator?(input) || is_number?(input))
  end

  def is_operator?(input)
    %w"+ - * /".include? input
  end

  def is_number?(input)
    !input.match(/^-?\d*\.?\d*$/).nil?
  end

  def execute_operation(input)
    return if  @values.size < 2
    left_val, right_val = @values.pop(2).map(&:to_f)
    result = left_val.send(input.to_sym, right_val)
    @values << result if result.finite?
    result
  end
end