require 'spec_helper'

describe Hotcell::Commands::Include do
  def parse source
    Hotcell::Template.parse(source)
  end

  let(:resolver_class) do
    Class.new(Hotcell::Resolver) do
      attr_reader :templates
      def initialize templates
        @templates = templates.stringify_keys
      end

      def resolve path, context = nil
        templates[path] or raise 'Template not found'
      end
    end
  end
  let(:templates) { {
    template1: 'Hello',
    template2: 'Hello, {{ name }}',
    template3: '{{ name }} - {{ action }}'
  } }
  let(:resolver) { resolver_class.new templates }
  let(:render_options) { { shared: { resolver: resolver } } }

  describe '#render' do
    specify { parse("{{ include 'template0' }}").render(render_options).should =~ /Template not found/ }
    specify { parse("{{ include 'template1' }}").render!(render_options).should == 'Hello' }
    specify { parse("{{ include 'template2' }}").render(render_options).should == 'Hello, ' }
    specify { parse(
      "{{ include 'template2', name: 'Pyrosha' }}"
    ).render(render_options).should == 'Hello, Pyrosha' }
    specify { parse(
      "{{! name = Pyrosha; action = 'CRUSH!' }}{{ include 'template3', name: 'Hulk' }}"
    ).render(render_options).should == 'Hulk - CRUSH!' }
  end
end
