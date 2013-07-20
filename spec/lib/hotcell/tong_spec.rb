require 'spec_helper'

describe Hotcell::Tong do
  context 'mixed in' do
    context do
      let(:klass) do
        Class.new(Numeric) do
          include Hotcell::Tong::Mixin

          def foo; end
        end
      end
      subject { klass.new }

      its(:tong_methods) { should be_a Set }
      its(:tong_methods) { should be_empty }
      its(:to_tong) { should === subject }
      specify { subject.tong_invoke('foo').should be_nil }
      specify { subject.tong_invoke(:foo).should be_nil }
      specify { subject.tong_invoke('foo', 42, :arg).should be_nil }
    end

    context do
      let(:klass) do
        Class.new(String) do
          include Hotcell::Tong::Mixin

          manipulate :foo, :bar

          alias_method :foo, :split
          alias_method :bar, :size
        end
      end
      subject { klass.new('hello world') }

      its(:to_tong) { should === subject }
      specify { (subject.tong_methods.to_a & %w(foo bar)).should =~ %w(foo bar) }
      specify { subject.tong_invoke('baz').should be_nil }
      specify { subject.tong_invoke('baz', 42, :arg).should be_nil }
      specify { subject.tong_invoke(:foo).should be_nil }
      specify { subject.tong_invoke('foo').should == %w(hello world) }
      specify { subject.tong_invoke('bar').should == 11 }
      specify { expect { subject.tong_invoke('bar', 42) }.to raise_error ArgumentError }
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

    its('tong_methods.to_a') { should =~ %w(foo bar) }
    its(:to_tong) { should === subject }
    specify { subject.tong_invoke('send').should be_nil }
    specify { subject.tong_invoke(:bar).should be_nil }
    specify { subject.tong_invoke('foo').should == 'foo' }
    specify { subject.tong_invoke('bar', 5, 8).should == 13 }
    specify { expect { subject.tong_invoke('bar') }.to raise_error ArgumentError }
  end
end
