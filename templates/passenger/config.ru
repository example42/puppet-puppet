# File managed by Puppet
# SSL needs to be handled outside this, though.

# if puppet is not in your RUBYLIB:
# $:.unshift('/opt/puppet/lib')

$0 = "puppetmasterd"
<% if scope.lookupvar('puppetversion') <= '2.6.1' -%>
 require 'puppet'
<% end %>

# if you want debugging:
# ARGV << "--debug"

ARGV << "--rack"
require 'puppet/application/puppetmasterd'
# we're usually running inside a Rack::Builder.new {} block,
# therefore we need to call run *here*.
run Puppet::Application[:puppetmasterd].run
