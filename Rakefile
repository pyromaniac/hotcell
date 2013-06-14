require "bundler/gem_tasks"

namespace :build do
  desc 'Build lexer'
  task :lexer do
    `ragel -R -T0 lib/puffer_markup/lexer.rl`
  end

  task :dot do
    `ragel -Vp lib/puffer_markup/lexer.rl > lexer.dot`
  end

  desc 'Build parser'
  task :parser do
    `racc -d -o lib/puffer_markup/parser.rb -O lib/puffer_markup/parser.out lib/puffer_markup/parser.y`
  end
end
