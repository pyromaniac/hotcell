require 'spec_helper'

describe Hotcell::Manipulator do
  context 'mixed in' do
    context do
      let(:klass) do
        Class.new(Numeric) do
          include Hotcell::Manipulator::Mixin
        end
      end
      subject { klass.new }

      its(:manipulator_methods) { should be_a Set }
      its(:manipulator_methods) { should be_empty }
      its(:to_manipulator) { should === subject }
      specify { subject.manipulator_invoke('round').should be_nil }
      specify { subject.manipulator_invoke(:round).should be_nil }
      specify { subject.manipulator_invoke('round', 42, :arg).should be_nil }
    end

    context do
      let(:klass) do
        Class.new(String) do
          include Hotcell::Manipulator::Mixin

          manipulator :split, :size
        end
      end
      subject { klass.new('hello world') }

      its('manipulator_methods.to_a') { should =~ %w(split size) }
      its(:to_manipulator) { should === subject }
      specify { subject.manipulator_invoke('length').should be_nil }
      specify { subject.manipulator_invoke('length', 42, :arg).should be_nil }
      specify { subject.manipulator_invoke(:split).should be_nil }
      specify { subject.manipulator_invoke('split').should == %w(hello world) }
      specify { subject.manipulator_invoke('size').should == 11 }
      specify { expect { subject.manipulator_invoke('size', 42) }.to raise_error ArgumentError }
    end
  end

  context 'inherited' do
    let(:klass) do
      Class.new(described_class) do
        def foo
          'foo'
        end

        def bar arg1, arg2
          arg1 + arg2
        end
      end
    end
    subject { klass.new }

    its('manipulator_methods.to_a') { should =~ %w(foo bar) }
    its(:to_manipulator) { should === subject }
    specify { subject.manipulator_invoke('send').should be_nil }
    specify { subject.manipulator_invoke(:bar).should be_nil }
    specify { subject.manipulator_invoke('foo').should == 'foo' }
    specify { subject.manipulator_invoke('bar', 5, 8).should == 13 }
    specify { expect { subject.manipulator_invoke('bar') }.to raise_error ArgumentError }
  end
end
