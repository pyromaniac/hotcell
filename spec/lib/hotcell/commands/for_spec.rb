require 'spec_helper'

describe Hotcell::Commands::For do
  def parse source
    Hotcell::Template.parse(source)
  end

  describe '#validate!' do
    specify { expect { parse('{{ for }}{{ end for }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `for` (0 for 2) at 1:4' }
    specify { expect { parse('{{ for item }}{{ end for }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `for` (1 for 2) at 1:4' }
    specify { expect { parse("{{ for 'item', in: [] }}{{ end for }}").syntax
      }.to raise_error Hotcell::SyntaxError, 'Expected IDENTIFER as first argument in `for` command at 1:4' }
  end

  describe '#render' do
    specify { parse('{{ for item, in: [1, 2, 3] }}{{ end for }}').render.should == '' }
    specify { parse('{{ for item, in: [1, 2, 3] }}{{ item }}{{ end for }}').render.should == '123' }
    specify { parse(
      '{{ for item, in: [1, 2, 3] }}{{ item }} * 3 = {{ item * 3 }}; {{ end for }}'
    ).render(reraise: true).should == '1 * 3 = 3; 2 * 3 = 6; 3 * 3 = 9; ' }
    specify { parse('{{ for item, in: [5, 6, 7], loop: true }}{{ loop.index }}{{ end for }}').render.should == '012' }
  end
end

describe Hotcell::Commands::For::Forloop do
  subject { described_class.new([5, 6, 7, 8], 2) }

  its(:prev) { should == 6 }
  its(:next) { should == 8 }
  its(:length) { should == 4 }
  its(:size) { should == 4 }
  its(:count) { should == 4 }
  its(:index) { should == 2 }
  its(:rindex) { should == 1 }
  its(:first) { should == false }
  its(:first?) { should == false }
  its(:last) { should == false }
  its(:last?) { should == false }

  context do
    subject { described_class.new([5, 6, 7, 8], 0) }

    its(:prev) { should be_nil }
    its(:next) { should == 6 }
    its(:first) { should be_true }
    its(:first?) { should be_true }
    its(:last) { should be_false }
    its(:last?) { should be_false }
  end

  context do
    subject { described_class.new([5, 6, 7, 8], 3) }

    its(:prev) { should == 7 }
    its(:next) { should be_nil }
    its(:first) { should be_false }
    its(:first?) { should be_false }
    its(:last) { should be_true }
    its(:last?) { should be_true }
  end
end
