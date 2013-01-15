require 'rubygems'
require 'bundler/setup'
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'memory_watch'
class Test::Unit::TestCase; end
