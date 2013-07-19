require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
Rake::ExtensionTask.new('lexerc') do |config|
  config.lib_dir = 'lib/hotcell'
end

task :default => :spec

desc 'Builds all the project'
task :project do
  %w(project:lexerr project:lexerc project:parser clobber compile).each do |task|
    Rake::Task[task].invoke
  end
end

namespace :project do
  desc 'Build lexer'
  task :lexerr do
    `ragel -R -F1 -I lib/hotcell lib/hotcell/lexerr.rl`
  end

  desc 'Build lexer'
  task :lexerc do
    `ragel -C -G2 -I lib/hotcell ext/lexerc/lexerc.rl`
  end

  task :dot do
    `ragel -Vp -I lib/hotcell lib/hotcell/lexerr.rl > lexerr.dot`
    `ragel -Vp -I lib/hotcell ext/lexerc/lexerc.rl > lexerc.dot`
  end

  desc 'Build parser'
  task :parser do
    `racc -o lib/hotcell/parser.rb -O lib/hotcell/parser.out lib/hotcell/parser.y`
  end
end
