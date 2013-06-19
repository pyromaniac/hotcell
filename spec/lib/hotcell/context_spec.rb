require 'spec_helper'

describe Hotcell::Context do
  describe '#initialize' do
    its('scope.scope') { should == [{}] }

    context do
      subject { described_class.new(
        scope: { foo: 42, 'bar' => 'baz' },
        variables: { baz: 'moo' },
        boo: 'goo',
        'taz' => 'man',
        rescuer: ->{},
        reraise: true
      ) }
      its('scope.scope') { should == [{foo: 42, 'bar' => 'baz', 'baz' => 'moo', 'boo' => 'goo', 'taz' => 'man'}] }
    end

    context do
      subject { described_class.new(variables: { foo: 42, 'bar' => 'baz' }, environment: { 'baz' => 'moo' }) }
      its('scope.scope') { should == [{'foo' => 42, 'bar' => 'baz', baz: 'moo'}] }
    end
  end

  describe '#safe' do
    specify { subject.safe { 3 }.should == 3 }
    specify { subject.safe(5) { 3 }.should == 3 }
    specify { subject.safe(nil) { 3 }.should == 3 }
    specify { subject.safe { 3 * 'foo' }.should =~ /TypeError/ }
    specify { subject.safe(nil) { 3 * 'foo' }.should == nil }
    specify { subject.safe(5) { 3 * 'foo' }.should == 5 }

    context 'reraise' do
      subject { described_class.new(reraise: true) }

      specify { subject.safe { 'foo' }.should == 'foo' }
      specify { subject.safe('bar') { 'foo' }.should == 'foo' }
      specify { expect { subject.safe { 3 * 'foo' } }.to raise_error TypeError }
      specify { expect { subject.safe('bar') { 3 * 'foo' } }.to raise_error TypeError }
    end

    context 'custom rescuer' do
      subject { described_class.new(rescuer: ->(e){ "Rescued from: #{e.class}" }) }
      specify { subject.safe { 3 * 'foo' }.should =~ /Rescued from: TypeError/ }
    end
  end

  describe '#manipulator_invoke' do
    subject { described_class.new(
      variables: { foo: 42, 'bar' => 'baz' }, environment: { 'baz' => 'moo' },
      helpers: Module.new do
        def strip string
          string.strip
        end

        def bar
          'bazzzzz'
        end
      end
    ) }
    specify { subject.manipulator_invoke('foo').should == 42 }
    specify { subject.manipulator_invoke('moo').should be_nil }
    specify { subject.manipulator_invoke('baz').should be_nil }
    specify { subject.manipulator_invoke('bar').should == 'baz' }
    specify { expect { subject.manipulator_invoke('bar', 42) }.to raise_error ArgumentError }
    specify { expect { subject.manipulator_invoke('strip') }.to raise_error ArgumentError }
    specify { subject.manipulator_invoke('strip', '  hello  ').should == 'hello' }
  end
end
