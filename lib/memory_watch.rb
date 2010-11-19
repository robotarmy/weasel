
class MemoryWatch
  attr_accessor :watch_string,:high_water_pids,:callback,:high_water_mb,:delay,:num_cycles,:num_over_marks,:pids
  def initialize(options)
    self.callback        = options[:callback]       || lambda {|pid| p pid}
    self.watch_string    = (options[:watch]         || "this poem is a pomme").strip
    self.delay           = options[:delay]          || 60
    self.num_cycles      = options[:num_cycles]     || 3
    self.num_over_marks  = options[:num_over_marks] || 2
    self.high_water_mb   = options[:high_water_mb]  || 700
    self.high_water_pids = {}
  end
  public
  def cycle
    self.num_cycles.times do 
      _check_pids
      sleep self.delay
    end
    _trigger_callback
  end

  private
  def _trigger_callback
    self.high_water_pids.each do |pid,over_marks|
      if over_marks.size >= self.num_over_marks
        self.callback.call(pid)
      end
    end
  end
  def _run
    p cmd = "ps x |grep '#{self.watch_string}' |grep -v grep | awk '{print $1}'"
    self.pids = %x{#{cmd}}.split()
    self.pids
  end
  def _check_pids
    _run.each { |pid|
      p memory_usage = %x{ps -o rss= -p #{pid}}.to_i # KB
      if memory_usage > self.high_water_mb * 1024 # 750MB
        puts "WARNING - Process #{pid} hit high water mark"
        self.high_water_pids[pid] ||= []
        self.high_water_pids[pid] << memory_usage
      end
    }
  end
end

