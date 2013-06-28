require 'spec_helper'

describe Hotcell::Commands::Scope do
  def parse source
    Hotcell::Template.parse(source)
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
