require 'spec_helper'

describe Hotcell::Context do
  its('scope.scope') { should == [{}] }
  its(:helpers) { should be_a Hotcell::Manipulator }

  describe '#normalize_options' do
    def result options = {}
      default = { scope: {}, shared: {}, helpers: [], reraise: false, rescuer: described_class::DEFAULT_RESCUER }
      default.merge options
    end
    let(:rscr) { ->{} }

    specify { subject.normalize_options({}).should == result }
    specify { subject.normalize_options(foo: 42, 'bar' => 'baz').should == result(
      scope: { 'foo' => 42, 'bar' => 'baz' }) }
    specify { subject.normalize_options(foo: 42, scope: { bar: 'baz' }).should == result(
      scope: { 'foo' => 42, bar: 'baz' }) }
    specify { subject.normalize_options(foo: 42, variables: { bar: 'baz' }).should == result(
      scope: { 'foo' => 42, 'bar' => 'baz' }) }
    specify { subject.normalize_options(foo: 42, environment: { 'bar' => 'baz' }).should == result(
      scope: { 'foo' => 42, bar: 'baz' }) }
    specify { subject.normalize_options(shared: {resolver: 'resolver'}).should == result(
      shared: {resolver: 'resolver'}) }
    specify { subject.normalize_options(helpers: 'helper1').should == result(
      helpers: ['helper1']) }
    specify { subject.normalize_options(helpers: ['helper1', 'helper2']).should == result(
      helpers: ['helper1', 'helper2']) }
    specify { subject.normalize_options(reraise: nil).should == result(reraise: false) }
    specify { subject.normalize_options(reraise: true).should == result(reraise: true) }
    specify { subject.normalize_options(reraise: 'foo').should == result(reraise: true) }
    specify { subject.normalize_options(rescuer: rscr).should == result(rescuer: rscr) }

    specify { subject.normalize_options(
      scope: { foo: 42, 'bar' => 'baz' },
      variables: { baz: 'moo' },
      environment: { hello: 'world' },
      boo: 'goo',
      'taz' => 'man',
      rescuer: rscr,
      reraise: true
    ).should == result(
      scope: { foo: 42, hello: 'world', 'bar' => 'baz', 'baz' => 'moo', 'boo' => 'goo', 'taz' => 'man' },
      rescuer: rscr,
      reraise: true
    ) }
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
