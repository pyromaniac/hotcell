require 'spec_helper'

describe PufferMarkup::Context do
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

  describe '#hotcell_invoke' do
    subject { described_class.new(variables: { foo: 42, 'bar' => 'baz' }, environment: { 'baz' => 'moo' }) }
    specify { subject.hotcell_invoke('foo').should == 42 }
    specify { subject.hotcell_invoke('moo').should be_nil }
  end
end
