require 'spec_helper'

describe Hotcell::Commands::Unless do
  def parse source
    Hotcell::Template.parse(source)
  end

  describe '#validate!' do
    specify { expect { parse('{{ unless }}{{ end unless }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `unless` (0 for 1) at 1:4' }
    specify { expect { parse('{{ unless true }}{{ else false }}{{ end unless }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `else` (1 for 0) at 1:21' }
    specify { expect { parse('{{ unless true }}{{ else }}{{ else }}{{ end unless }}').syntax
      }.to raise_error Hotcell::BlockError, 'Unexpected subcommand `else` for `unless` command at 1:31' }
    specify { expect { parse('{{ unless true }}{{ elsif }}{{ end unless }}').syntax
      }.to raise_error Hotcell::BlockError, 'Unexpected subcommand `elsif` for `unless` command at 1:21' }
  end

  describe '#render' do
    specify { parse('{{ unless true }}Hello{{ end unless }}').render.should == '' }
    specify { parse('{{ unless false }}Hello{{ end unless }}').render.should == 'Hello' }
    specify { parse('{{ unless true }}Hello{{ else }}World{{ end unless }}').render.should == 'World' }
    specify { parse('{{ unless false }}Hello{{ else }}World{{ end unless }}').render.should == 'Hello' }
  end
end
