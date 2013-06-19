require 'spec_helper'

describe PufferMarkup::Template do
  describe '.parse' do
    before do
      PufferMarkup.stub(:commands) { { 'include' => Class.new } }
      PufferMarkup.stub(:blocks) { { 'for' => Class.new } }
      PufferMarkup.stub(:subcommands) { { 'else' => Class.new } }
    end

    specify { described_class.parse('').should be_a described_class }
    specify { described_class.parse('').options.should == {
      commands: ['include'], blocks: ['for'], subcommands: ['else']
    } }
  end

  describe '#syntax' do
    specify { described_class.new('').syntax.should be_a PufferMarkup::Joiner }
    specify { described_class.new('hello').syntax.should be_a PufferMarkup::Joiner }
    specify { described_class.new('hello {{ tag }}').syntax.should be_a PufferMarkup::Joiner }
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
  end
end
