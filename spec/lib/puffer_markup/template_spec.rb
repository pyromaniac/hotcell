require 'spec_helper'

describe PufferMarkup::Template do
  describe '#syntax' do
    specify { described_class.new('').syntax.should be_a PufferMarkup::Document }
    specify { described_class.new('hello').syntax.should be_a PufferMarkup::Document }
    specify { described_class.new('hello {{ tag }}').syntax.should be_a PufferMarkup::Document }
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
