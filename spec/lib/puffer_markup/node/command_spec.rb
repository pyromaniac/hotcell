require 'spec_helper'

describe PufferMarkup::Command do
  let(:context) { PufferMarkup::Context.new }

  describe 'complex parsing and rendering' do
    def parse source
      PufferMarkup::Template.parse(source)
    end

    let(:include_tag) do
      Class.new(described_class) do
        def validate!
          raise PufferMarkup::Errors::ArgumentError.new('Template path is required') if children.count != 1
        end

        def process context, path
          "included #{path}"
        end
      end
    end

    before { PufferMarkup.stub(:commands) { { 'include' => include_tag } } }
    before { PufferMarkup.stub(:blocks) { {} } }
    before { PufferMarkup.stub(:subcommands) { {} } }

    specify { parse("{{ include 'template/path' }}").render(context).should == 'included template/path' }
    specify { expect {
      parse("{{ include }}").syntax
    }.to raise_error PufferMarkup::Errors::ArgumentError }
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
