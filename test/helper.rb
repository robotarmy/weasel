require 'rubygems'
require 'test/unit'
require "bundler/setup"
require 'wrong/adapters/test_unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'memory_watch'

class Test::Unit::TestCase
end
