require 'spec_helper'

describe Hotcell::Commands::Scope do
  def parse source
    Hotcell::Template.parse(source)
  end

  describe '#validate!' do
    specify { expect { parse('{{ scope \'hello\' }}{{ end scope }}').syntax
      }.to raise_error Hotcell::SyntaxError, 'Expected first argument to be a HASH in `scope` at 1:4' }
  end

  describe '#render' do
    specify { parse(
      '{{ count = 42 }} {{ scope count: count + 8 }}{{ count }}{{ end scope }} {{ count }}'
    ).render.should == '42 50 42' }
    specify { parse(
      '{{! captured = scope }}Hello{{ end scope }} {{ captured }}'
    ).render(reraise: true).should == ' Hello' }
  end
end
