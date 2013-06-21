require 'spec_helper'

describe Hotcell::Tag do
  let(:context) { Hotcell::Context.new }

  context 'complex parsing and rendering' do
    def parse source
      Hotcell::Template.parse(source)
    end

    specify { parse("{{ 'Hello' }}").render.should == 'Hello' }
    specify { parse("{{! 'Hello' }}").render.should == '' }
    specify { parse("{{ res = 'Hello' }} {{ res }}").render.should == 'Hello Hello' }
    specify { parse("{{! res = 'Hello' }} {{ res }}").render.should == ' Hello' }
  end
end
