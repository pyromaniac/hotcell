require 'spec_helper'

describe Hotcell::Config do
  subject { Hotcell::Config.send(:new) }

  let(:command_class) { Class.new(Hotcell::Command) }
  let(:block_class) do
    Class.new(Hotcell::Block) do
      subcommands :else, :elsif
    end
  end
  let(:misc_class) { Class.new }

  specify { subject.blocks.should == {} }
  specify { subject.subcommands.should == {} }
  specify { subject.commands.should == {} }
  specify { subject.helpers.should == [] }

  describe '#register_command' do
    context do
      before { subject.register_command :for, command_class }
      specify { subject.blocks.should == {} }
      specify { subject.subcommands.should == {} }
      specify { subject.commands.should == { 'for' => command_class } }
    end

    context do
      before { subject.register_command 'for', block_class }
      specify { subject.blocks.should == { 'for' => block_class } }
      specify { subject.subcommands.should == { 'else' => block_class, 'elsif' => block_class } }
      specify { subject.commands.should == {} }
    end

    context do
      before { subject.register_command 'for', block_class }
      before { subject.register_command :forloop, block_class }
      before { subject.register_command :include, command_class }
      specify { subject.blocks.should == { 'for' => block_class, 'forloop' => block_class } }
      specify { subject.commands.should == { 'include' => command_class } }
    end

    context do
      before { subject.register_command 'for' => block_class, forloop: block_class, include: command_class }
      specify { subject.blocks.should == { 'for' => block_class, 'forloop' => block_class } }
      specify { subject.commands.should == { 'include' => command_class } }
    end

    context 'errors' do
      context do
        specify { expect { subject.register_command :for, misc_class }.to raise_error }
      end

      context do
        before { subject.register_command 'for', block_class }
        specify { expect { subject.register_command :for, command_class }.to raise_error }
      end

      context do
        before { subject.register_command :for, command_class }
        specify { expect { subject.register_command 'for', block_class }.to raise_error }
      end
    end
  end

  describe '#register_helpers' do
    context do
      3.times do |i|
        let("helper#{i+1}") { Module.new }
      end
      before { subject.register_helpers helper1, helper2 }
      before { subject.register_helpers helper1 }
      before { subject.register_helpers [helper3] }

      specify { subject.helpers.should == [helper1, helper2, helper3] }
    end
  end
end
