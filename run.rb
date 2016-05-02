require_relative 'calculator'

class Run
  def run
    print_instructions

    calculate = Calculator.new

    input = ''

    while input != 'q' && !input.nil? do
      print "> "

      user_input = gets
      input = user_input.nil? ? nil : user_input.chomp.strip
      puts calculate.execute(input) unless input.nil?
    end
  end

  def print_instructions
    puts "Welcome to the RPN Calculator! At any time, please type 'q' or press CTRL+D to exit."
    puts "Have Fun!"
  end
end