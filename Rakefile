require "bundler/gem_tasks"

namespace :build do
  desc 'Build lexer'
  task :lexer do
    `ragel -R -T0 lib/puffer_markup/lexer.rl`
  end

  desc 'Build parser'
  task :parser do
    `racc -o lib/puffer_markup/parser.rb lib/puffer_markup/parser.y`
  end
end
