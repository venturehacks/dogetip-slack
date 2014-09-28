require 'bundler/setup'

DOGETIP_ROOT = File.dirname(__FILE__)
$:.unshift File.join(DOGETIP_ROOT, 'lib')
require 'dogetip-slack'

DogetipSlack.boot