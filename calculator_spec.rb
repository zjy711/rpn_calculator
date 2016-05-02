require 'rspec'
require_relative 'calculator'

RSpec.describe 'Calculator' do
  before do
    # remove the noise from test output
    allow(subject).to receive(:print)
    allow(subject).to receive(:puts)
  end

  subject { Calculator.new }

  describe '#execute' do
    it 'does not execute if input should be ignored' do
      allow(subject).to receive(:is_operator?)
      allow(subject).to receive(:ignore?).with('should ignore').and_return true

      subject.execute('should ignore')
      expect(subject).not_to have_received(:is_operator?).with('should ignore')
    end

    it 'executes operaion when input is an operator' do
      allow(subject).to receive(:execute_operation)
      allow(subject).to receive(:ignore?).with('is operator').and_return false
      allow(subject).to receive(:is_operator?).with('is operator').and_return true

      subject.execute('is operator')
      expect(subject).to have_received(:execute_operation).with('is operator')
    end

    it 'pushes the input into @values if input is a number' do
      number = double(:number, to_f: "-123.456".to_f)
      allow(subject).to receive(:ignore?).with(number).and_return false

      subject.execute(number)
      expect(subject.instance_variable_get(:@values)).not_to include('-123.456')
    end

    context 'executes multiple inputs' do
      it '+ operation' do
        subject.execute('1')
        subject.execute('10')
        subject.execute('+')
        expect(subject.instance_variable_get(:@values)).to eq [11]
      end

      it '- operation' do
        subject.execute('11')
        subject.execute('110')
        subject.execute('-')
        expect(subject.instance_variable_get(:@values)).to eq [-99]
      end

      it '* operation' do
        subject.execute('2')
        subject.execute('24')
        subject.execute('*')
        expect(subject.instance_variable_get(:@values)).to eq [48]
      end

      it '/ operation' do
        subject.execute('100')
        subject.execute('-10')
        subject.execute('/')
        expect(subject.instance_variable_get(:@values)).to eq [-10]
      end

      it 'executes multiple steps' do
        subject.execute('5')
        subject.execute('8')
        subject.execute('+')
        subject.execute('-3')
        subject.execute('-2')
        subject.execute('*')
        subject.execute('5')
        subject.execute('+')
        subject.execute('2')
        subject.execute('9')
        subject.execute('3')
        subject.execute('+')
        subject.execute('*')
        subject.execute('20')
        subject.execute('13')
        subject.execute('-')
        subject.execute('2')
        subject.execute('/') 

        expect(subject.instance_variable_get(:@values).last).to eq 3.5
      end
    end
  end

  describe '#ignore?' do
    context 'ignores the step if input is' do
      it 'an empty string' do
        expect(subject.ignore?('')).to be true
      end

      it 'neither number nor operator' do
        expect(subject.ignore?('Q')).to be true
      end
    end

    context 'does not ignore the step if input is' do
      it 'number' do
        expect(subject.ignore?('12.23456')).to be false
      end

      it 'operator' do
        expect(subject.ignore?('+')).to be false
      end
    end
  end

  describe '#is_operator?' do
    context 'when input is an operator' do
      specify { expect(subject.is_operator?('+')).to be true }
      specify { expect(subject.is_operator?('-')).to be true }
      specify { expect(subject.is_operator?('*')).to be true }
      specify { expect(subject.is_operator?('/')).to be true }
    end

    context 'when input is not an operator' do
      specify { expect(subject.is_operator?('%')).to be false }
      specify { expect(subject.is_operator?('1')).to be false }
      specify { expect(subject.is_operator?('abc')).to be false }
    end
  end

  describe '#is_number?' do
    context 'when input is an integer' do
      specify { expect(subject.is_number?('-123')).to be true }
      specify { expect(subject.is_number?('1')).to be true }
      specify { expect(subject.is_number?('2')).to be true }
      specify { expect(subject.is_number?('0')).to be true }
      specify { expect(subject.is_number?('100000')).to be true }
    end

    context 'when input is a float number' do
      specify { expect(subject.is_number?('-12.123')).to be true }
      specify { expect(subject.is_number?('.')).to be true }
      specify { expect(subject.is_number?('.1')).to be true }
      specify { expect(subject.is_number?('11.')).to be true }
      specify { expect(subject.is_number?('1.23')).to be true }
      specify { expect(subject.is_number?('13.344216')).to be true }
    end

    context 'when input is not a number' do
      specify { expect(subject.is_number?('- 11')).to be false }
      specify { expect(subject.is_number?('-11 .11')).to be false }
      specify { expect(subject.is_number?('11 22 33')).to be false }
      specify { expect(subject.is_number?('..11')).to be false }
      specify { expect(subject.is_number?('.12.3')).to be false }
      specify { expect(subject.is_number?('abc.123')).to be false }
      specify { expect(subject.is_number?('12ab.23')).to be false }
      specify { expect(subject.is_number?('12ab')).to be false }
      specify { expect(subject.is_number?('12.ab12')).to be false }
      specify { expect(subject.is_number?('12.12ab')).to be false }
      specify { expect(subject.is_number?('12.ab')).to be false }
    end
  end

  describe '#execute_operation' do
    it 'does not execute operation if there are less than 2 values stored' do
      subject.instance_variable_set(:@values, [5.0])

      subject.execute_operation('+')
      expect(subject.instance_variable_get(:@values)).to eq [5.0]
    end

    context 'when operation is result is finitie' do
      it 'removes the values and stores the result as new value' do
        subject.instance_variable_set(:@values, [5.0, 3.0, 1.0, 2.0, 6.0])

        subject.execute_operation('+')
        expect(subject.instance_variable_get(:@values)).to eq [5.0, 3.0, 1.0, 8.0]
      end
    end

    context 'when operation result is infinite' do
      it 'removes the values and does not store the result' do
        subject.instance_variable_set(:@values, [5.0, 3.0, 1.0, 2.0, 0.0])

        subject.execute_operation('/')
        expect(subject.instance_variable_get(:@values)).to eq [5.0, 3.0, 1.0]
      end
    end

    context 'when operation result is not a number' do
      it 'removes the values and does not store the result' do
        subject.instance_variable_set(:@values,  [5.0, 3.0, 1.0, 0.0, 0.0])

        subject.execute_operation('/')
        expect(subject.instance_variable_get(:@values)).to eq [5.0, 3.0, 1.0]
      end
    end
  end
end