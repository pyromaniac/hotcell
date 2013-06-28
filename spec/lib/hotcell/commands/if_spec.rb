require 'spec_helper'

describe Hotcell::Commands::If do
  def parse source
    Hotcell::Template.parse(source)
  end

  describe '#validate!' do
    specify { expect { parse('{{ if }}{{ end if }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `if` (0 for 1) at 1:4' }
    specify { expect { parse('{{ if true }}{{ else true }}{{ end if }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `else` (1 for 0) at 1:17' }
    specify { expect { parse('{{ if true }}{{ elsif }}{{ end if }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `elsif` (0 for 1) at 1:17' }
    specify { expect { parse('{{ if true }}{{ else }}{{ elsif true }}{{ end if }}').syntax
      }.to raise_error Hotcell::BlockError, 'Unexpected `else` for `if` command at 1:17' }
    specify { expect { parse('{{ if true }}{{ else true }}{{ elsif true }}{{ end if }}').syntax
      }.to raise_error Hotcell::BlockError, 'Unexpected `else` for `if` command at 1:17' }
    specify { expect { parse('{{ if true }}{{ else }}{{ else }}{{ end if }}').syntax
      }.to raise_error Hotcell::BlockError, 'Unexpected `else` for `if` command at 1:17' }
  end

  describe '#render' do
    specify { parse('{{ if true }}Hello{{ end if }}').render.should == 'Hello' }
    specify { parse('{{ if false }}Hello{{ end if }}').render.should == '' }
    specify { parse('{{ if true }}Hello{{ else }}World{{ end if }}').render.should == 'Hello' }
    specify { parse('{{ if false }}Hello{{ else }}World{{ end if }}').render.should == 'World' }
    specify { parse('{{ if true }}Hello{{ elsif true }}Beautiful{{ else }}World{{ end if }}').render.should == 'Hello' }
    specify { parse('{{ if false }}Hello{{ elsif true }}Beautiful{{ else }}World{{ end if }}').render.should == 'Beautiful' }
    specify { parse('{{ if false }}Hello{{ elsif false }}Beautiful{{ else }}World{{ end if }}').render.should == 'World' }
    specify { parse('{{ if false }}Hello{{ elsif true }}Beautiful{{ elsif true }}Ruby{{ else }}World{{ end if }}').render.should == 'Beautiful' }
    specify { parse('{{ if false }}Hello{{ elsif false }}Beautiful{{ elsif true }}Ruby{{ else }}World{{ end if }}').render.should == 'Ruby' }
    specify { parse('{{ if false }}Hello{{ elsif false }}Beautiful{{ elsif false }}Ruby{{ else }}World{{ end if }}').render.should == 'World' }
  end
end
