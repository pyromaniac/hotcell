require 'spec_helper'

describe Hotcell::Block do
  def method_missing method, *args, &block
    klass = Hotcell::Calculator::HANDLERS[method] ?
      Hotcell::Calculator : Hotcell::Node

    instance = Hotcell::Assigner.new *args if method == :ASSIGN
    instance = Hotcell::Summoner.new *args if method == :METHOD
    klass = Hotcell::Arrayer if [:ARRAY, :PAIR].include?(method)
    klass = Hotcell::Hasher if method == :HASH
    klass = Hotcell::Sequencer if method == :SEQUENCE

    klass = Hotcell::Tag if method == :TAG
    instance = Hotcell::Command.new *args if method == :COMMAND
    instance = Hotcell::Block.new *args if method == :BLOCK
    klass = Hotcell::Joiner if method == :JOINER

    instance || klass.new(method, *args)
  end

  let(:context) { Hotcell::Context.new }

  context 'complex parsing and rendering' do
    def parse source
      Hotcell::Template.parse(source)
    end

    let(:if_tag) do
      Class.new(described_class) do
        subcommand :else
        subcommand :elsif

        def validate!
          names = subcommands.map { |subcommand| subcommand.name }
          valid = names.empty? || (
            names.any? && names.last.in?('elsif', 'else') &&
            names[0..-2].uniq.in?(['elsif'], [])
          )
          raise Hotcell::BlockError.new 'Invalid if syntax', *position_info unless valid
        end

        def process context, condition
          conditions = [[condition]]
          subnodes.each do |subnode|
            if subnode.is_a?(Hotcell::Command)
              conditions.last[1] = '' if conditions.last[1] == nil
              conditions << (subnode.name == 'elsif' ? [subnode.render_children(context).first] : [true])
            else
              conditions.last[1] = subnode.render(context)
            end
          end
          condition = conditions.detect { |condition| !!condition[0] }
          condition ? condition[1] : nil
        end
      end
    end

    before { Hotcell.stub(:commands) { {} } }
    before { Hotcell.stub(:blocks) { { 'if' => if_tag } } }

    specify { parse('{{ if true }}Hello{{ end if }}').render.should == 'Hello' }
    specify { parse('{{! if true }}Hello{{ end if }}').render.should == '' }
    specify { parse('{{ res = if true }}Hello{{ end if }} {{ res }}').render.should == 'Hello Hello' }
    specify { parse('{{! res = if true }}Hello{{ end if }} {{ res }}').render.should == ' Hello' }

    context do
      subject(:template) { parse(<<-SOURCE
        {{ if value == 'hello' }}
          hello
        {{ elsif value == 'world' }}
          world
        {{ else }}
          foobar
        {{ end if }}
        SOURCE
      ) }
      specify { subject.render(value: 'hello').strip.should == 'hello' }
      specify { subject.render(value: 'world').strip.should == 'world' }
      specify { subject.render(value: 'foo').strip.should == 'foobar' }
    end

    context do
      subject(:template) { parse("{{ if value == 'hello' }}{{ elsif value == 'world' }}world{{ end if }}") }
      specify { subject.render(value: 'hello').should == '' }
      specify { subject.render(value: 'world').should == 'world' }
      specify { subject.render(value: 'foo').should == '' }
    end

    context do
      subject(:template) { parse("{{ if value == 'hello' }}{{ else }}world{{ end if }}") }
      specify { subject.render(value: 'hello').should == '' }
      specify { subject.render(value: 'foo').should == 'world' }
    end

    context do
      specify { expect {
        parse("{{ if value == 'hello' }}{{ else }}world{{ elsif }}{{ end if }}").syntax
      }.to raise_error Hotcell::BlockError }
    end
  end

  describe '.subcommands' do
    subject { Class.new(described_class) }

    before { subject.subcommand elsif: Class.new(Hotcell::Command), else: Class.new(Hotcell::Command) }
    its('subcommands.keys') { should == %w(elsif else) }

    context do
      before { subject.subcommand :when }
      its('subcommands.keys') { should == %w(elsif else when) }
    end
  end

  describe '#subcommands' do
    specify { described_class.new('if',
      subnodes: [COMMAND('elsif'), JOINER(), COMMAND('else'), JOINER()]).subcommands.should == [
        COMMAND('elsif'), COMMAND('else')
      ] }
  end

  describe '#render' do
    let(:block) do
      Class.new(described_class) do
        def process context, condition
          "condition #{condition}"
        end
      end
    end

    specify { block.new('if').render(context).should =~ /ArgumentError/ }
    specify { block.new('if', true).render(context).should == "condition true" }
  end

  context '#validate!' do
    let(:block) do
      Class.new(described_class) do
        subcommand :else
        def process context, subnodes, condition
          "condition #{condition}"
        end
      end
    end

    context do
      subject { block.new('if', true, subnodes: [TEMPLATE('hello')] ) }
      specify { expect { subject.validate! }.not_to raise_error }
    end

    context do
      subject { block.new('if', true, subnodes: [COMMAND('else')] ) }
      specify { expect { subject.validate! }.not_to raise_error }
    end

    context do
      subject { block.new('if', true, subnodes: [COMMAND('case')] ) }
      specify { expect { subject.validate! }.to raise_error }
    end
  end
end
