require 'rspec'
require_relative 'run'
require_relative 'calculator'

RSpec.describe Run do
  subject { Run.new }

  before do
    # remove the noise from test output
    allow(subject).to receive(:puts)
    allow(subject).to receive(:print)
  end

  describe '#run' do
    context 'sets up correctly' do
      before do
        allow(subject).to receive(:gets).and_return 'q'
        allow(Calculator).to receive(:new).and_return(double(execute: 'test'))
      end

      it 'news an instance of Calculator' do
        subject.run
        expect(Calculator).to have_received(:new)
      end

      it 'prints the instruction' do
        allow(subject).to receive(:print_instructions)

        subject.run
        expect(subject).to have_received(:print_instructions)
      end
    end

    context 'quits the program' do
      before do
        @calculator = double(:calculator)
        allow(Calculator).to receive(:new).and_return(@calculator)
      end

      it 'if user types q' do
        allow(@calculator).to receive(:execute).with('q')
        allow(subject).to receive(:gets).and_return('q', '123')

        subject.run
        expect(@calculator).not_to have_received(:execute).with('123')
      end
    end
  end
end