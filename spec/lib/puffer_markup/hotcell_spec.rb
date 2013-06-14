require 'spec_helper'

describe PufferMarkup::Hotcell do
  context 'mixed in' do
    context do
      let(:klass) do
        Class.new(Numeric) do
          include PufferMarkup::Hotcell::Mixin
        end
      end
      subject { klass.new }

      its(:hotcell_methods) { should be_a Set }
      its(:hotcell_methods) { should be_empty }
      its(:to_hotcell) { should === subject }
      specify { subject.hotcell_invoke('round').should be_nil }
      specify { subject.hotcell_invoke(:round).should be_nil }
      specify { subject.hotcell_invoke('round', 42, :arg).should be_nil }
    end

    context do
      let(:klass) do
        Class.new(String) do
          include PufferMarkup::Hotcell::Mixin

          hotcell :split, :size
        end
      end
      subject { klass.new('hello world') }

      its('hotcell_methods.to_a') { should =~ %w(split size) }
      its(:to_hotcell) { should === subject }
      specify { subject.hotcell_invoke('length').should be_nil }
      specify { subject.hotcell_invoke('length', 42, :arg).should be_nil }
      specify { subject.hotcell_invoke(:split).should be_nil }
      specify { subject.hotcell_invoke('split').should == %w(hello world) }
      specify { subject.hotcell_invoke('size').should == 11 }
      specify { expect { subject.hotcell_invoke('size', 42) }.to raise_error ArgumentError }
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

    its('hotcell_methods.to_a') { should =~ %w(foo bar) }
    its(:to_hotcell) { should === subject }
    specify { subject.hotcell_invoke('send').should be_nil }
    specify { subject.hotcell_invoke(:bar).should be_nil }
    specify { subject.hotcell_invoke('foo').should == 'foo' }
    specify { subject.hotcell_invoke('bar', 5, 8).should == 13 }
    specify { expect { subject.hotcell_invoke('bar') }.to raise_error ArgumentError }
  end
end
