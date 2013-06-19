require "bundler/gem_tasks"

namespace :build do
  desc 'Build lexer'
  task :lexer do
    `ragel -R -T0 lib/hotcell/lexer.rl`
  end

  task :dot do
    `ragel -Vp lib/hotcell/lexer.rl > lexer.dot`
  end

  desc 'Build parser'
  task :parser do
    `racc -d -o lib/hotcell/parser.rb -O lib/hotcell/parser.out lib/hotcell/parser.y`
  end
end
