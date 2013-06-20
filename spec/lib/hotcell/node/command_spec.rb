require 'spec_helper'

describe Hotcell::Command do
  let(:context) { Hotcell::Context.new }

  describe 'complex parsing and rendering' do
    def parse source
      Hotcell::Template.parse(source)
    end

    let(:include_tag) do
      Class.new(described_class) do
        def validate!
          raise Hotcell::ArgumentError.new('Template path is required', *name.hotcell_position) if children.count != 1
        end

        def process context, path
          "included #{path}"
        end
      end
    end

    before { Hotcell.stub(:commands) { { 'include' => include_tag } } }
    before { Hotcell.stub(:blocks) { {} } }
    before { Hotcell.stub(:subcommands) { {} } }

    specify { parse("{{ include 'template/path' }}").render(context).should == 'included template/path' }
    specify { expect {
      parse("{{ include }}").syntax
    }.to raise_error Hotcell::ArgumentError }
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
    specify { command.new('include', mode: :silence).render(context).should =~ /ArgumentError/ }
    specify { command.new('include', 'path').render(context).should == "rendered path" }
    specify { command.new('include', 'path', mode: :silence).render(context).should == '' }

    context 'assigning' do
      before { subject.render(context) }

      context do
        subject { command.new('include', assign: 'inclusion') }
        specify { context.key?('inclusion').should be_false }
      end

      context do
        subject { command.new('include', mode: :silence, assign: 'inclusion') }
        specify { context.key?('inclusion').should be_false }
      end

      context do
        subject { command.new('include', 'path', assign: 'inclusion') }
        specify { context['inclusion'].should == "rendered path" }
      end

      context do
        subject { command.new('include', 'path', mode: :silence, assign: 'inclusion') }
        specify { context['inclusion'].should == "rendered path" }
      end
    end
  end
end
