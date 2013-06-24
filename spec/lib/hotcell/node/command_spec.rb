require 'spec_helper'

describe Hotcell::Command do
  let(:context) { Hotcell::Context.new }

  context 'complex parsing and rendering' do
    def parse source
      Hotcell::Template.parse(source)
    end

    let(:include_tag) do
      Class.new(described_class) do
        def validate!
          raise Hotcell::ArgumentError.new('Template path is required', *position_info) if children.count != 1
        end

        def process context, path
          "included #{path}"
        end
      end
    end

    before { Hotcell.stub(:commands) { { 'include' => include_tag } } }
    before { Hotcell.stub(:blocks) { {} } }
    before { Hotcell.stub(:subcommands) { {} } }

    specify { expect { parse("{{ include }}").syntax }.to raise_error Hotcell::ArgumentError }
    specify { parse("{{ include 'template/path' }}").render(context).should == 'included template/path' }
    specify { parse("{{ include 'template/path' }}").render.should == 'included template/path' }
    specify { parse("{{! include 'template/path' }}").render.should == '' }
    specify { parse("{{ res = include 'template/path' }} {{ res }}").render.should == 'included template/path included template/path' }
    specify { parse("{{! res = include 'template/path' }} {{ res }}").render.should == ' included template/path' }
  end

  describe '#render' do
    let(:command) do
      Class.new(described_class) do
        def process context, path
          "rendered #{path}"
        end
      end
    end

    specify { command.new('include').render(context).should =~ /ArgumentError/ }
    specify { command.new('include', 'path').render(context).should == "rendered path" }
  end
end
