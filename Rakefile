require "bundler/gem_tasks"

namespace :build do
  desc 'Build lexer'
  task :lexer do
    `ragel -R -F1 lib/hotcell/lexer.rl`
  end

  task :dot do
    `ragel -Vp lib/hotcell/lexer.rl > lexer.dot`
  end

  desc 'Build parser'
  task :parser do
    `racc -o lib/hotcell/parser.rb -O lib/hotcell/parser.out lib/hotcell/parser.y`
  end
end

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
