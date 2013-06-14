require 'spec_helper'

describe PufferMarkup::Scope do
  subject { described_class.new }
  describe '#initialize' do
    its(:scope) { should == [{}] }
    specify { described_class.new(foo: 1, 'bar' => 2).send(:scope).should == [{foo: 1, 'bar' => 2}] }
  end

  describe '#push' do
    context do
      before { subject.push(hello: 'world') }
      its(:scope) { should == [{}, {hello: 'world'}] }
    end

    context do
      before do
        subject.push(hello: 'world')
        subject.push(hello: 'hell', foo: 42)
      end
      its(:scope) { should == [{}, {hello: 'world'}, {hello: 'hell', foo: 42}] }
    end
  end

  describe '#pop' do
    subject { described_class.new bar: 'baz' }
    before do
      subject.send(:cache)
      subject.push(hello: 'world')
      subject.push(hello: 'hell', foo: 42)
      subject.send(:cache)
    end

    context do
      specify { subject[:bar].should == 'baz' }
      specify { subject[:hello].should == 'hell' }
      specify { subject[:foo].should == 42 }
    end

    context do
      before { subject.pop }
      its(:scope) { should == [{bar: 'baz'}, {hello: 'world'}] }
      specify { subject[:bar].should == 'baz' }
      specify { subject[:hello].should == 'world' }
      specify { subject[:foo].should be_nil }
    end

    context do
      before { 2.times { subject.pop } }
      its(:scope) { should == [{bar: 'baz'}] }
      specify { subject[:bar].should == 'baz' }
      specify { subject[:hello].should be_nil }
      specify { subject[:foo].should be_nil }
    end

    context do
      before { 4.times { subject.pop } }
      its(:scope) { should == [{bar: 'baz'}] }
      specify { subject[:bar].should == 'baz' }
      specify { subject[:hello].should be_nil }
      specify { subject[:foo].should be_nil }
    end
  end

  describe '#scoped' do
    specify do
      subject.send(:scope).should == [{}]
      subject.scoped(foo: 'bar') do
        subject.send(:scope).should == [{}, {foo: 'bar'}]
        subject.scoped(moo: 'baz', hello: 42) do
          subject.send(:scope).should == [{}, {foo: 'bar'}, {moo: 'baz', hello: 42}]
        end
        subject.send(:scope).should == [{}, {foo: 'bar'}]
      end
      subject.send(:scope).should == [{}]
    end

    specify 'exception safety' do
      begin
        subject.send(:scope).should == [{}]
        subject.scoped(foo: 'bar') do
          subject.send(:scope).should == [{}, {foo: 'bar'}]
          raise
        end
      rescue
        subject.send(:scope).should == [{}]
      end
    end
  end

  describe '#[]' do
    subject { described_class.new bar: 'baz' }

    specify { subject[:foo].should be_nil }
    specify { subject['bar'].should be_nil }
    specify { subject[:bar].should == 'baz' }

    context do
      before do
        subject.push(hello: 42)
        subject.push(bar: 'world')
      end

      specify { subject[:hello].should == 42 }
      specify { subject[:bar].should == 'world' }
    end
  end

  describe '#key?' do
    subject { described_class.new bar: 'baz' }

    specify { subject.key?(:foo).should be_false }
    specify { subject.key?('bar').should be_false }
    specify { subject.key?(:bar).should be_true }

    context do
      before do
        subject.push(hello: 42)
        subject.push(bar: 'world')
      end

      specify { subject.key?(:hello).should be_true }
      specify { subject.key?(:bar).should be_true }
    end
  end

  describe '#[]=' do
    subject { described_class.new bar: 'baz' }

    context do
      before do
        subject['foo'] = 1
        subject[:foo] = 2
      end

      its(:scope) { should == [{bar: "baz", 'foo' => 1, foo: 2}] }
      specify { subject['foo'].should == 1 }
      specify { subject[:foo].should == 2 }
    end

    context do
      before do
        subject.push(hello: 42)
        subject.push(bar: 'world')
        subject.send(:cache)
      end

      before do
        subject['foo'] = 1
        subject[:bar] = 2
        subject[:hello] = 3
      end

      its(:scope) { should == [{bar: 'baz'}, {hello: 3}, {bar: 2, 'foo' => 1}] }
      specify { subject['foo'].should == 1 }
      specify { subject[:bar].should == 2 }
      specify { subject[:hello].should == 3 }
    end
  end
end
