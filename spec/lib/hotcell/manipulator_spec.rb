require 'spec_helper'

describe Hotcell::Manipulator do
  context 'mixed in' do
    context do
      let(:klass) do
        Class.new(Numeric) do
          include Hotcell::Manipulator::Mixin

          def foo; end
        end
      end
      subject { klass.new }

      its(:manipulator_methods) { should be_a Set }
      its(:manipulator_methods) { should be_empty }
      its(:to_manipulator) { should === subject }
      specify { subject.manipulator_invoke('foo').should be_nil }
      specify { subject.manipulator_invoke(:foo).should be_nil }
      specify { subject.manipulator_invoke('foo', 42, :arg).should be_nil }
    end

    context do
      let(:klass) do
        Class.new(String) do
          include Hotcell::Manipulator::Mixin

          manipulate :foo, :bar

          alias_method :foo, :split
          alias_method :bar, :size
        end
      end
      subject { klass.new('hello world') }

      its(:to_manipulator) { should === subject }
      specify { (subject.manipulator_methods.to_a & %w(foo bar)).should =~ %w(foo bar) }
      specify { subject.manipulator_invoke('baz').should be_nil }
      specify { subject.manipulator_invoke('baz', 42, :arg).should be_nil }
      specify { subject.manipulator_invoke(:foo).should be_nil }
      specify { subject.manipulator_invoke('foo').should == %w(hello world) }
      specify { subject.manipulator_invoke('bar').should == 11 }
      specify { expect { subject.manipulator_invoke('bar', 42) }.to raise_error ArgumentError }
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
