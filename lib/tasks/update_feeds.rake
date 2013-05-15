# Put this in Rakefile (doesn't matter where)
require 'benchmark'
 
class Rake::Task
  def execute_with_benchmark(*args)
    bm = Benchmark.measure { execute_without_benchmark(*args) }
    puts "   #{name} --> #{bm}"
  end
 
  alias_method :execute_without_benchmark, :execute
  alias_method :execute, :execute_with_benchmark
end


namespace :feeds do
  task :update => [:environment] do
    Feed.update_feeds
  end
end
