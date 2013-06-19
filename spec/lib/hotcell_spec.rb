require 'spec_helper'

describe Hotcell do
  it { should respond_to :commands }
  it { should respond_to :blocks }
  it { should respond_to :subcommands }
  it { should respond_to :register_command }
end
