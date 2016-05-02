require_relative 'calculator'

class Run
  def run
    print_instructions

    calculate = Calculator.new

    input = nil

    while input != 'q' do
      print "> "
      input = gets.chomp.strip
      puts calculate.execute(input)
    end
  end

  def print_instructions
    puts "Welcome to the RPN Calculator! At any time, please type 'q' to exit."
    puts "Have Fun!"
  end
end