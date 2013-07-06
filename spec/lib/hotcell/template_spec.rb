require 'spec_helper'

describe Hotcell::Template do
  describe '.parse' do
    before do
      Hotcell.stub(:commands) { { 'include' => Class.new } }
      Hotcell.stub(:blocks) { { 'for' => Class.new } }
    end

    specify { described_class.parse('').should be_a described_class }
    specify { described_class.parse(''
      ).options.slice(:commands, :blocks).values.map(&:keys).should == [['include'], ['for']] }
  end

  describe '#syntax' do
    specify { described_class.new('').syntax.should be_a Hotcell::Joiner }
    specify { described_class.new('hello').syntax.should be_a Hotcell::Joiner }
    specify { described_class.new('hello {{ tag }}').syntax.should be_a Hotcell::Joiner }
  end

  describe '#render' do
    context do
      subject { described_class.new('Hello, {{ name }}!') }
      specify { subject.render.should == 'Hello, !' }
      specify { subject.render(variables: { name: 'Friend' }).should == 'Hello, Friend!' }
    end

    context do
      subject { described_class.new('Hello, {{ name * 2 }}!') }
      specify { subject.render.should =~ /Hello.*NoMethodError/ }
      specify { subject.render(variables: { name: 'Friend' }).should == 'Hello, FriendFriend!' }
    end

    context do
      subject { described_class.new('Hello, {{! name }}!') }
      specify { subject.render(variables: { name: 'Friend' }).should == 'Hello, !' }
    end

    context do
      let(:helper) do
        Module.new do
          def name string
            string.capitalize
          end
        end
      end
      subject { described_class.new("Hello, {{ name('pyra') }}!") }
      specify { subject.render(helpers: helper).should == 'Hello, Pyra!' }

      context do
        before { Hotcell.stub(:helpers) { [helper] } }
        specify { subject.render.should == 'Hello, Pyra!' }
        specify { subject.render(helpers: []).should == 'Hello, !' }
      end
    end
  end

  describe 'render!' do
    subject { described_class.new('Hello, {{ 2 * foo }}!') }
    specify { expect { subject.render! }.to raise_error TypeError }
    specify { expect { subject.render!(foo: 42) }.not_to raise_error }
    specify { expect { subject.render!(bar: 42) }.to raise_error TypeError }
    specify { expect { subject.render!(Hotcell::Context.new) }.to raise_error TypeError }
  end

  context 'complex tags test' do
    specify { described_class.parse(<<-SOURCE
        {{ for i, in: [1, 2, 3, 4] }}
          {{ if i % 2 == 1 }}
            {{ i }}
          {{ end if }}
        {{ end for }}
      SOURCE
    ).render.gsub(/[\s\n]+/, ' ').strip.should == '1 3' }

    specify { described_class.parse(<<-SOURCE
        {{ for i, in: [1, 2, 3, 4] }}
          {{ for j, in: [4, 3, 2, 1] }}
            {{ i * j }}
          {{ end for }}
        {{ end for }}
      SOURCE
    ).render.gsub(/[\s\n]+/, ' ').strip.should == '4 3 2 1 8 6 4 2 12 9 6 3 16 12 8 4' }

    context 'method invokation' do
      specify { described_class.parse("{{ [1, 2, 3][1] }}").render.should == '2' }
      specify { described_class.parse("{{ [1, 2, 3][1..2] }}").render.should == '[2, 3]' }
      specify { described_class.parse("{{ [1, 2, 3].last }}").render.should == '3' }
      specify { described_class.parse("{{ [1, 2, 3]['last'] }}").render.should =~ /TypeError/ }
      specify { described_class.parse("{{ { a: 1, b: 2 }['b'] }}").render.should == '2' }
      specify { described_class.parse("{{ { count: 5, b: 7 }.count }}").render.should == '2' }
      specify { described_class.parse("{{ { count: 5, b: 7 }.b }}").render.should == '7' }
      specify { described_class.parse("{{ { count: 5, b: 7 }['count'] }}").render.should == '5' }
      specify { described_class.parse("{{ { count: 5, b: 7 }['b'] }}").render.should == '7' }
      specify { described_class.parse("{{ { count: 5, b: 7 }['size'] }}").render.should == '' }
      specify { described_class.parse("{{ 'string'[1] }}").render.should == 't' }
      specify { described_class.parse("{{ 'string'[1, 3] }}").render.should == 'tri' }
      specify { described_class.parse("{{ 'string'.size }}").render.should == '6' }
      specify { described_class.parse("{{ 'string'['size'] }}").render.should == '' }
    end
  end

  context 'escaping' do
    specify { described_class.parse('{{ title }}').render(
      title: '<h1>Title</h1>'
    ).should == '<h1>Title</h1>' }
    specify { described_class.parse('{{~ title }}').render(
      title: '<h1>Title</h1>'
    ).should == '<h1>Title</h1>' }
    specify { described_class.parse('{{ if true }}<h1>Title</h1>{{ end }}').render(
      title: '<h1>Title</h1>'
    ).should == '<h1>Title</h1>' }
    specify { described_class.parse('{{^ if true }}<h1>Title</h1>{{ end }}').render(
      title: '<h1>Title</h1>'
    ).should == '&lt;h1&gt;Title&lt;/h1&gt;' }
    specify { described_class.parse('{{ if true }}{{ title }}{{ end }}').render(
      title: '<h1>Title</h1>'
    ).should == '<h1>Title</h1>' }

    context 'escape_tags' do
      before { Hotcell.stub(:escape_tags) { true } }

      specify { described_class.parse('{{ title }}').render(
        title: '<h1>Title</h1>'
      ).should == '&lt;h1&gt;Title&lt;/h1&gt;' }
      specify { described_class.parse('{{ if true }}{{ title }}{{ end }}').render(
        title: '<h1>Title</h1>'
      ).should == '&lt;h1&gt;Title&lt;/h1&gt;' }
      specify { described_class.parse('{{ if true }}<h1>Title</h1>{{ end }}').render(
        title: '<h1>Title</h1>'
      ).should == '<h1>Title</h1>' }
    end
  end
end
