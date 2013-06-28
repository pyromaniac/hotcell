require 'spec_helper'

describe Hotcell::Commands::If do
  def parse source
    Hotcell::Template.parse(source)
  end

  describe '#validate!' do
    specify { expect { parse('{{ case }}{{ end case }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `case` (0 for 1) at 1:4' }
    specify { expect { parse('{{ case 42 }}{{ when }}{{ end case }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `when` (0 for 1..Infinity) at 1:17' }
    specify { expect { parse('{{ case 42 }}{{ when 42 }}{{ else 42 }}{{ end case }}').syntax
      }.to raise_error Hotcell::ArgumentError, 'Wrond number of arguments for `else` (1 for 0) at 1:30' }
    specify { expect { parse('{{ case 42 }}{{ end case }}').syntax
      }.to raise_error Hotcell::BlockError, 'Expected `when` for `case` command at 1:4' }
    specify { expect { parse('{{ case 42 }}foo{{ when 42 }}{{ end case }}').syntax
      }.to raise_error Hotcell::BlockError, 'Expected `when` for `case` command at 1:12' }
    specify { expect { parse('{{ case 42 }}{{ else }}{{ end case }}').syntax
      }.to raise_error Hotcell::BlockError, 'Unexpected `else` for `case` command at 1:17' }
    specify { expect { parse('{{ case 42 }}{{ when 42 }}{{ else }}{{ when 43 }}{{ end case }}').syntax
      }.to raise_error Hotcell::BlockError, 'Unexpected `else` for `case` command at 1:30' }
  end

  describe '#render' do
    specify { parse('{{ case 42 }}{{ when 42 }}Hello{{ end case }}').render.should == 'Hello' }
    specify { parse('{{ case 42 }}{{ when 43 }}Hello{{ end case }}').render.should == '' }
    specify { parse('{{ case 42 }}{{ when 42 }}Hello{{ when 43}}World{{ end case }}').render.should == 'Hello' }
    specify { parse('{{ case 43 }}{{ when 42 }}Hello{{ when 43}}World{{ end case }}').render.should == 'World' }
    specify { parse('{{ case 42 }}{{ when 42, 43 }}Hello{{ else }}World{{ end case }}').render.should == 'Hello' }
    specify { parse('{{ case 43 }}{{ when 42, 43 }}Hello{{ else }}World{{ end case }}').render.should == 'Hello' }
    specify { parse('{{ case 44 }}{{ when 42, 43 }}Hello{{ else }}World{{ end case }}').render.should == 'World' }
    specify { parse("{{ case 'hello' }}{{ when 'hello', 'world' }}Hello{{ else }}World{{ end case }}").render.should == 'Hello' }
    specify { parse("{{ case 'world' }}{{ when 'hello', 'world' }}Hello{{ else }}World{{ end case }}").render.should == 'Hello' }
    specify { parse("{{ case 'foo' }}{{ when 'hello', 'world' }}Hello{{ else }}World{{ end case }}").render.should == 'World' }
  end
end
