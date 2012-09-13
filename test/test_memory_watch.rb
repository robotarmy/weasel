require 'helper'
class TestMemoryWatch < Test::Unit::TestCase
  def setup
    @cmd = %q{ruby ./bin/weasel --delay 999999 --num_cycles 9900000099}
    pid = fork { %x{#{@cmd}} }
    Process.detach(pid)
  end

  def teardown
    @wm.pids.each do |pid|
      %x{kill -9 #{pid}}
    end
  end

  def test_watches_self
    @wm = MemoryWatch.new(:watch => @cmd , :high_water_mb => 0.02,:delay => 0.1, :num_cycles => 1)
    @wm.cycle
    assert_equal 1, @wm.high_water_pids.size
  end

  def test_runs_callback
    test_magiggy = false
    @wm = MemoryWatch.new(:watch => @cmd,
                         :high_water_mb => 0,
                         :num_cycles => 1,
                         :delay => 0.01,
                         :num_over_marks => 0,
                         :callback => lambda {|pid|
                            test_magiggy = pid
                         },
                         :callback_message => 'Message')
    @wm.cycle
    assert_includes @wm.high_water_pids, test_magiggy
  end
end
